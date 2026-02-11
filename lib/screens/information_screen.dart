import '../widgets/vr_splitter.dart';
import "dart:async";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';
import 'package:audioplayers/audioplayers.dart';

/// State 0.5 - HIV Information Screen
/// Displays definition of HIV before role selection
class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  late PageController _leftPageController;
  late PageController _rightPageController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentPage = 0;
  final int _totalPages = 2; // Intro + Hook
  Duration? _hookAudioDuration;
  StreamSubscription? _playerCompleteSubscription;
  Timer? _introTextTimer;

  @override
  void initState() {
    super.initState();
    final controller = context.read<AppController>();
    _currentPage = controller.initialInformationPage;

    // Create distinct controllers for each eye to correctly handle PageView gestures/animations
    _leftPageController = PageController(initialPage: _currentPage);
    _rightPageController = PageController(initialPage: _currentPage);

    // If starting on Hook Page (1), play audio immediately
    if (_currentPage == 1) {
      Future.delayed(Duration.zero, () {
        if (mounted) _playIntroVoiceover();
      });
    } else {
      // If on Intro Page (0), start timer for text reading
      _startIntroTextTimer();
    }

    _playerCompleteSubscription =
        _audioPlayer.onPlayerComplete.listen((event) async {
      // Audio finished (Hook page), wait 2s then next
      if (mounted && _currentPage == 1) {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted && _currentPage == 1) {
          _nextPage();
        }
      }
    });
  }

  void _startIntroTextTimer() {
    _introTextTimer?.cancel();
    // 12 seconds for reading "Kata Pengantar"
    _introTextTimer = Timer(const Duration(seconds: 12), () {
      if (mounted && _currentPage == 0) {
        _nextPage();
      }
    });
  }

  @override
  void dispose() {
    _introTextTimer?.cancel();
    _playerCompleteSubscription?.cancel();
    _leftPageController.dispose();
    _rightPageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  // ... (keep audio methods same) ...

  Future<void> _playIntroVoiceover() async {
    try {
      await _audioPlayer.stop();
      final source = AssetSource('sounds/vo/intro.mp3');
      await _audioPlayer.setSource(source);
      final duration = await _audioPlayer.getDuration();
      if (mounted) {
        setState(() {
          _hookAudioDuration = duration;
        });
        await _audioPlayer.resume();
      }
    } catch (e) {
      debugPrint('Error playing intro VO: $e');
      if (mounted) {
        setState(() {
          _hookAudioDuration = null;
        });
      }
    }
  }

  void _nextPage() {
    final soundManager = SoundManager();
    soundManager.playButtonPress();
    if (_currentPage < _totalPages - 1) {
      // Animate BOTH eyes simultaneously
      const duration = Duration(milliseconds: 300);
      const curve = Curves.easeInOut;

      _leftPageController.animateToPage(_currentPage + 1,
          duration: duration, curve: curve);
      _rightPageController.animateToPage(_currentPage + 1,
          duration: duration, curve: curve);
    } else {
      context.read<AppController>().proceedFromInformation();
    }
  }

  void _previousPage() {
    final soundManager = SoundManager();
    soundManager.playButtonPress();
    if (_currentPage > 0) {
      const duration = Duration(milliseconds: 300);
      const curve = Curves.easeInOut;

      _leftPageController.animateToPage(_currentPage - 1,
          duration: duration, curve: curve);
      _rightPageController.animateToPage(_currentPage - 1,
          duration: duration, curve: curve);
    }
  }

  void _onPageChanged(int index) {
    // Only update state once (can rely on either controller, but state is shared)
    if (_currentPage != index) {
      setState(() {
        _currentPage = index;
      });

      if (index == 1) {
        _playIntroVoiceover();
      } else {
        _audioPlayer.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.read<AppController>().goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: VRSplitter(
          builder: (context, eyeIndex) {
            // Pass the specific controller for this eye
            return Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.cosmicBackground,
              ),
              child: SafeArea(
                child: _InformationContent(
                  pageController: eyeIndex == 0
                      ? _leftPageController
                      : _rightPageController,
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  hookAudioDuration: _hookAudioDuration,
                  onPageChanged: _onPageChanged,
                  onNext: _nextPage,
                  onPrevious: _previousPage,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InformationContent extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int totalPages;
  final Duration? hookAudioDuration;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _InformationContent({
    Key? key,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
    required this.hookAudioDuration,
    required this.onPageChanged,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            physics:
                const NeverScrollableScrollPhysics(), // Prevent user drag conflict
            controller: pageController,
            onPageChanged: onPageChanged,
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
            key: ValueKey('hook_$hookAudioDuration'),
            text:
                'Menurut kamu, kenapa orang dengan HIV bisa tidak sadar kalau dirinya terinfeksi? Yuk kita pelajari perjalanan infeksinya!',

            // Pass the dynamic duration if available
            duration: hookAudioDuration,

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
          if (currentPage > 0)
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
                onPressed: onPrevious,
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
            children: List.generate(totalPages, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.3),
                  boxShadow: currentPage == index
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
              onPressed: onNext,
              icon: Icon(currentPage == totalPages - 1
                  ? Icons.check
                  : Icons.arrow_forward),
              label: Text(currentPage == totalPages - 1 ? 'SELESAI' : 'LANJUT'),
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
