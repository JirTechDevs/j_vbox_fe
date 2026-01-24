import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';

import '../models/education_slide.dart';

/// State 7 - Final Education Screen
/// Interactive slideshow with voiceovers
class FinalEducationScreen extends StatefulWidget {
  const FinalEducationScreen({Key? key}) : super(key: key);

  @override
  State<FinalEducationScreen> createState() => _FinalEducationScreenState();
}

class _FinalEducationScreenState extends State<FinalEducationScreen> {
  final PageController _pageController = PageController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentIndex = 0;
  Duration? _currentSlideDuration; // Duration for current slide synchronization

  // Placeholder data - TO BE REPLACED WITH USER CONTENT
  final List<EducationSlide> _slides = [
    const EducationSlide(
      title: 'Apa itu HIV?',
      content:
          'Kita mulai dari HIV yang bahasa ilmiahnya Human Immunodeficiency Virus. Maknanya:\n\nHuman → manusia\nImmunodeficiency → lemah/rusaknya sistem imun\nVirus → virus\n\nJadi, HIV adalah virus yang masuk ke dalam tubuh manusia yang menyebabkan lemah dan rusaknya sistem imun, sehingga tubuh menjadi lebih rentan terhadap berbagai infeksi dan penyakit.',
      audioPath: 'sounds/definisi_hiv.mp3',
    ),
    const EducationSlide(
      title: 'Apa itu AIDS?',
      content:
          'Lalu, AIDS (Acquired Immunodeficiency Syndrome) maknanya:\n\nAcquired → tertular\nImmunodeficiency → rusaknya sistem imun\nSyndrome → kumpulan gejala\n\nJadi, AIDS adalah kumpulan gejala penyakit akibat rusaknya sistem imun, yang merupakan tahap lanjutan dari infeksi HIV.',
      audioPath: 'sounds/definisi_aids.mp3',
    ),
    const EducationSlide(
      title: 'Cara Penularan',
      content: 'Penjelasan tentang cara penularan (penyebab)...',
      audioPath: 'sounds/edu_cause.mp3', // Placeholder
    ),
    const EducationSlide(
      title: 'Tanda & Gejala',
      content: 'Penjelasan tentang tanda dan gejala (window period)...',
      audioPath: 'sounds/edu_symptoms.mp3', // Placeholder
    ),
    const EducationSlide(
      title: 'Pencegahan',
      content: 'Langkah-langkah pencegahan...',
      audioPath: 'sounds/edu_prevention.mp3', // Placeholder
    ),
    const EducationSlide(
      title: 'Penanganan',
      content: 'Informasi pengobatan dan cek rutin...',
      audioPath: 'sounds/edu_treatment.mp3', // Placeholder
    ),
    const EducationSlide(
      title: 'Pesan Penting',
      content: 'Imbauan dan pengingat akhir...',
      audioPath: 'sounds/edu_reminder.mp3', // Placeholder
    ),
  ];

  @override
  void initState() {
    super.initState();
    _playCurrentSlideAudio();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.stop(); // Ensure audio stops when leaving screen
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCurrentSlideAudio() async {
    try {
      await _audioPlayer.stop();
      final slide = _slides[_currentIndex];

      // Reset duration first to clear previous animation state if needed
      if (mounted) {
        setState(() {
          _currentSlideDuration = null;
        });
      }

      if (slide.audioPath.isNotEmpty) {
        final source = AssetSource(slide.audioPath);

        // Load and get duration
        await _audioPlayer.setSource(source);
        final duration = await _audioPlayer.getDuration();

        if (mounted) {
          setState(() {
            _currentSlideDuration = duration;
          });
          await _audioPlayer.resume();
        }
      }
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      // Finished
      final controller = context.read<AppController>();
      controller.startRoleSelection();
    }
  }

  void _previousSlide() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine background based on slide index for variety (optional)
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Optional: Allow exit confirm? For now, nothing to keep flow strict.
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.cosmicBackground,
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header / Progress
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0), // Reduced from 8
                  child: Text(
                    'Edukasi HIV/AIDS (${_currentIndex + 1}/${_slides.length})',
                    style: AppTextStyles.bodyText.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 10, // Reduced size
                    ),
                  ),
                ),

                // Slide Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable swipe to force buttons? Or allow?
                    // Let's allow swipe but satisfy button usage too.
                    // Actually, for guided experience, buttons are safer.
                    itemCount: _slides.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      _playCurrentSlideAudio();
                    },
                    itemBuilder: (context, index) {
                      return _buildSlide(_slides[index]);
                    },
                  ),
                ),

                // Navigation Controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      if (_currentIndex > 0)
                        _buildNavButton(
                          icon: Icons.arrow_back,
                          label: 'Kembali',
                          onPressed: _previousSlide,
                          color: AppColors.secondary,
                        )
                      else
                        const SizedBox(width: 140), // Spacer

                      // Next / Finish Button
                      _buildNavButton(
                        icon: _currentIndex == _slides.length - 1
                            ? Icons.check_circle
                            : Icons.arrow_forward,
                        label: _currentIndex == _slides.length - 1
                            ? 'Selesai'
                            : 'Lanjut',
                        onPressed: _nextSlide,
                        color: _currentIndex == _slides.length - 1
                            ? AppColors.success
                            : AppColors.primary,
                        isPrimary: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(EducationSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 8.0), // Reduced outer margin to make container wider
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16), // Increased internal padding slightly
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16), // Smaller radius
            border: Border.all(color: Colors.white10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slide.title,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 18, // Reduced from 20
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4), // Reduced from 8
                Container(
                  height: 1.5,
                  width: 40, // Reduced length
                  color: AppColors.accent,
                ),
                const SizedBox(height: 8), // Reduced from 12
                _FadingText(
                  key: ValueKey(
                      '${slide.title}_$_currentSlideDuration'), // Reset on title change or duration ready
                  text: slide.content,
                  duration: _currentSlideDuration, // Sync with audio!
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 12,
                    height: 1.15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
    bool isPrimary = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20), // Smaller icon
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16, // Smaller font
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? color : AppColors.secondary,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 12), // Compact padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class _FadingText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration? duration;

  const _FadingText({
    Key? key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
    this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Split by space to animate word by word
    final words = text.split(' ');

    // Use explicit duration if available (Synced), else fallback to estimate
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
