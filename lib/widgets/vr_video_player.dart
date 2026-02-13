import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

/// VR Video Player Widget
/// Displays video in split-screen mode (left/right) for VR Box viewing
/// Supports playing a sequence of videos for flashback scenarios
class VRVideoPlayer extends StatefulWidget {
  final List<String> videoPaths; // Support multiple videos in sequence
  final VoidCallback onVideoComplete;

  const VRVideoPlayer({
    Key? key,
    required this.videoPaths,
    required this.onVideoComplete,
  }) : super(key: key);

  @override
  State<VRVideoPlayer> createState() => _VRVideoPlayerState();
}

class _VRVideoPlayerState extends State<VRVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showPlayButton = false;
  String _debugStatus = 'Initializing...';
  int _currentVideoIndex = 0;

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

  /// Initialize video player for current video in sequence
  Future<void> _initializeVideo() async {
    try {
      if (_currentVideoIndex >= widget.videoPaths.length) {
        // All videos completed
        widget.onVideoComplete();
        return;
      }

      setState(() => _debugStatus =
          'Loading video ${_currentVideoIndex + 1}/${widget.videoPaths.length}...');

      final currentVideoPath = widget.videoPaths[_currentVideoIndex];
      _controller = VideoPlayerController.asset(currentVideoPath);

      await _controller.initialize();
      setState(
          () => _debugStatus = 'Video ${_currentVideoIndex + 1} initialized.');

      await _controller.setLooping(false);

      // Listen for video completion
      _controller.addListener(_videoListener);

      // Try Auto-play
      try {
        await _controller.play();
      } catch (e) {
        print("Autoplay blocked/failed: $e");
        setState(() {
          _showPlayButton = true;
          _debugStatus = 'Tap to start';
        });
      }

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _debugStatus = 'Error: $e';
      });
      print('Video initialization error: $e');
    }
  }

  /// Listen for video completion
  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      // Current video completed
      _controller.removeListener(_videoListener);
      _playNextVideo();
    }
  }

  /// Play next video in sequence
  Future<void> _playNextVideo() async {
    await _controller.dispose();
    _currentVideoIndex++;

    if (_currentVideoIndex < widget.videoPaths.length) {
      // More videos to play
      setState(() {
        _isInitialized = false;
        _showPlayButton = false;
      });
      await _initializeVideo();
    } else {
      // All videos completed
      widget.onVideoComplete();
    }
  }

  /// Manual play action
  void _playVideo() {
    _controller.play().then((_) {
      setState(() {
        _showPlayButton = false;
      });
    });
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

    return Stack(
      children: [
        _buildVRView(),
        if (_showPlayButton || !_controller.value.isPlaying)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _playVideo,
                  icon: const Icon(Icons.play_arrow, size: 32),
                  label: const Text("START VR EXPERIENCE",
                      style: TextStyle(fontSize: 20)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Text(
              _debugStatus,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
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
              'File: ${widget.videoPaths[_currentVideoIndex]}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _debugStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
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
