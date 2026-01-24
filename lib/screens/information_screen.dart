import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';
import 'package:audioplayers/audioplayers.dart';

/// State 0.5 - HIV Information Screen
/// Displays definition of HIV before role selection
class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final soundManager = SoundManager();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        controller.goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.cosmicBackground,
          ),
          child: SafeArea(
            child: _InformationPageView(
              controller: controller,
              soundManager: soundManager,
            ),
          ),
        ),
      ),
    );
  }
}

class _InformationPageView extends StatefulWidget {
  final AppController controller;
  final SoundManager soundManager;

  const _InformationPageView({
    Key? key,
    required this.controller,
    required this.soundManager,
  }) : super(key: key);

  @override
  State<_InformationPageView> createState() => _InformationPageViewState();
}

class _InformationPageViewState extends State<_InformationPageView> {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentPage = 0;
  final int _totalPages = 2; // Intro + Hook
  Duration? _hookAudioDuration; // Duration of the hook VO

  @override
  void initState() {
    super.initState();
    // Pre-fetch duration for the hook if possible, or just wait for page turn
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playIntroVoiceover() async {
    try {
      await _audioPlayer.stop();
      final source = AssetSource('sounds/vo/intro.mp3');

      // Set source first to get duration
      await _audioPlayer.setSource(source);
      final duration = await _audioPlayer.getDuration();

      setState(() {
        _hookAudioDuration = duration;
      });

      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Error playing intro VO: $e');
      // Fallback: Set duration to null to use default speed
      setState(() {
        _hookAudioDuration = null;
      });
    }
  }

  void _nextPage() {
    widget.soundManager.playButtonPress();
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.controller.proceedFromInformation();
    }
  }

  void _previousPage() {
    widget.soundManager.playButtonPress();
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });

              // Play VO if on Hook page (Index 1)
              if (index == 1) {
                _playIntroVoiceover();
              } else {
                _audioPlayer.stop();
              }
            },
            children: [
              _buildDisclaimerPage(),
              _buildHookPage(),
            ],
          ),
        ),
        _buildNavigationControls(),
      ],
    );
  }

  Widget _buildDisclaimerPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kata Pengantar',
              style: AppTextStyles.title.copyWith(
                color: AppColors.primary,
                shadows: [
                  const Shadow(
                    color: AppColors.primary,
                    blurRadius: 10,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.5), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: _FadingText(
                text:
                    'Aplikasi ini dirancang sebagai ruang aman untuk belajar tanpa menghakimi, konten dikembangkan dengan prinsip non-diskriminasi, non-stigmatisasi, dan berorientasi pada perubahan perilaku sesuai tujuan pencegahan HIV.',
                style: AppTextStyles.bodyText.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHookPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border:
                Border.all(color: AppColors.primary.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 15,
              ),
            ],
          ),
          child: _FadingText(
            // Rebuild when duration changes to restart/resync animation
            key: ValueKey('hook_$_hookAudioDuration'),
            text:
                'Menurut kamu, kenapa orang dengan HIV bisa tidak sadar kalau dia terinfeksi? Yuk kita pelajari perjalanan infeksinya!',

            // Pass the dynamic duration if available
            duration: _hookAudioDuration,

            style: AppTextStyles.bodyText.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
          if (_currentPage > 0)
            Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                      color: AppColors.secondary,
                      blurRadius: 8,
                      offset: Offset(0, 0))
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton.icon(
                onPressed: _previousPage,
                icon: const Icon(Icons.arrow_back),
                label: const Text('KEMBALI'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shadowColor: Colors.transparent,
                ),
              ),
            )
          else
            const SizedBox(width: 100), // Spacer

          // Page Indicator
          Row(
            children: List.generate(_totalPages, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                  boxShadow: _currentPage == index
                      ? [
                          const BoxShadow(
                              color: AppColors.primary, blurRadius: 8)
                        ]
                      : [],
                ),
              );
            }),
          ),

          // Next/Finish Button
          Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: AppColors.primary,
                    blurRadius: 10,
                    offset: Offset(0, 0))
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton.icon(
              onPressed: _nextPage,
              icon: Icon(_currentPage == _totalPages - 1
                  ? Icons.check
                  : Icons.arrow_forward),
              label:
                  Text(_currentPage == _totalPages - 1 ? 'SELESAI' : 'LANJUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FadingText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration? duration; // Optional explicit duration

  const _FadingText({
    Key? key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');

    // Use explicit duration if provided, otherwise estimate fallback
    final animationDuration =
        duration ?? Duration(milliseconds: words.length * 80 + 1000);

    return TweenAnimationBuilder<double>(
      duration: animationDuration,
      tween: Tween(begin: 0.0, end: words.length.toDouble()),
      builder: (context, value, child) {
        List<TextSpan> children = [];
        for (int i = 0; i < words.length; i++) {
          double opacity = (value - i).clamp(0.0, 1.0);
          children.add(
            TextSpan(
              text: words[i] + (i < words.length - 1 ? ' ' : ''),
              style: style.copyWith(
                color: style.color?.withOpacity(opacity) ??
                    Colors.white.withOpacity(opacity),
              ),
            ),
          );
        }
        return RichText(
          text: TextSpan(children: children),
          textAlign: textAlign,
        );
      },
    );
  }
}
