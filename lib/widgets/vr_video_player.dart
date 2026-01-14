import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// VR Video Player Widget
/// Displays video in split-screen mode (left/right) for VR Box viewing
/// No user controls - auto-plays and auto-exits on completion
class VRVideoPlayer extends StatefulWidget {
  final String videoPath;
  final VoidCallback onVideoComplete;

  const VRVideoPlayer({
    Key? key,
    required this.videoPath,
    required this.onVideoComplete,
  }) : super(key: key);

  @override
  State<VRVideoPlayer> createState() => _VRVideoPlayerState();
}

class _VRVideoPlayerState extends State<VRVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _enterFullscreen();
  }

  /// Enter fullscreen mode (hide system UI)
  void _enterFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// Exit fullscreen mode (restore system UI)
  void _exitFullscreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Initialize video player
  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);

      await _controller.initialize();
      await _controller.setLooping(false);

      // Listen for video completion
      _controller.addListener(_videoListener);

      // Auto-play video
      await _controller.play();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      print('Video initialization error: $e');
    }
  }

  /// Listen for video completion
  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      // Video completed - trigger callback
      _controller.removeListener(_videoListener);
      widget.onVideoComplete();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    _exitFullscreen();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorView();
    }

    if (!_isInitialized) {
      return _buildLoadingView();
    }

    return _buildVRView();
  }

  /// Build VR split-screen view
  Widget _buildVRView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: Row(
            children: [
              // Left eye
              Expanded(
                child: VideoPlayer(_controller),
              ),
              // Right eye (same video)
              Expanded(
                child: VideoPlayer(_controller),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build loading view
  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }

  /// Build error view
  Widget _buildErrorView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.videocam_off,
              color: Colors.white,
              size: 64,
            ),
            const SizedBox(height: 16),
            const Text(
              'Video Not Available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '(${widget.videoPath})',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: widget.onVideoComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('SKIP SCENARIO'),
            ),
          ],
        ),
      ),
    );
  }
}
