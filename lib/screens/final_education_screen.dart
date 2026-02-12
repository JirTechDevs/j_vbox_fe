import '../widgets/vr_splitter.dart';
import "dart:async";
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
  late PageController _leftPageController;
  late PageController _rightPageController;
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _currentIndex = 0;
  Duration? _currentSlideDuration; // Duration for current slide synchronization

  // Placeholder data - TO BE REPLACED WITH USER CONTENT
  final List<EducationSlide> _slides = [
    const EducationSlide(
      title: 'Apa itu HIV?',
      content:
          'Kita mulai dari HIV yang bahasa ilmiahnya Human Immunodeficiency Virus. Jika diartikan per-kata, maknanya:\n\nHuman → manusia\nImmunodeficiency → lemah/rusaknya sistem imun\nVirus → virus\n\nJadi, HIV adalah virus yang masuk ke dalam tubuh manusia yang menyebabkan lemah dan rusaknya sistem imun, sehingga tubuh menjadi lebih rentan terhadap berbagai infeksi dan penyakit.',
      audioPath: 'sounds/vo/definition.mp3',
    ),
    const EducationSlide(
      title: 'Apa itu AIDS?',
      content:
          'Lalu, AIDS atau bahasa ilmiahnya Acquired Immunodeficiency Syndrome yang jika diartikan perkata yaitu: :\n\nAcquired → terkena/tertular\nImmunodeficiency → rusak/lemahnya sistem imun\nSyndrome → kumpulan gejala\n\nJadi, AIDS merupakan kumpulan gejala penyakit karena rusak atau lemahnya sistem imun tubuh yang disebabkan oleh penularan suatu penyakit. Dalam hal ini, AIDS merupakan tahap lanjutan dari infeksi virus HIV.',
      audioPath: 'sounds/vo/definition_aids.mp3',
    ),
    const EducationSlide(
      title: 'Cara Penularan',
      content:
          'HIV menular melalui hubungan seksual tanpa pengaman, penggunaan jarum suntik bersama, transfusi darah yang tidak aman, serta dari ibu ke bayi saat kehamilan, persalinan, atau menyusui.',
      audioPath: 'sounds/vo/spread.mp3',
    ),
    const EducationSlide(
      title: 'Tanda & Gejala (1/4)',
      content:
          'Berawal dari \'periode jendela\' (Window Period), artinya dimulai sejak virus HIV masuk ke dalam tubuh sampai tes HIV bisa mendeteksinya. Karena itu, hasil tes HIV masih bisa negatif, meskipun orang tersebut sudah terinfeksi dan bisa menularkan HIV.',
      audioPath: 'sounds/vo/sign1.mp3',
    ),
    const EducationSlide(
      title: 'Tanda & Gejala (2/4)',
      content:
          'Selanjutnya, fase pertama. Infeksi Awal.\nSaat itu, orang yang terinfeksi akan mengira ini penyakit flu biasa karena virus HIV masih belum terdeteksi dan tes darah masih bisa negatif. Risiko penularannya sangat tinggi dan fase ini terjadi 2 minggu sampai 3 bulan setelah virus masuk ke dalam tubuh.',
      audioPath: 'sounds/vo/sign2.mp3',
    ),
    const EducationSlide(
      title: 'Tanda & Gejala (3/4)',
      content:
          'Fase Laten. Fase yang paling lama dan bisa saja tidak disadari. Saat tes dilakukan, hasilnya sudah positif dan virus bisa menular kepada orang lain meskipun berkembang lebih lambat. Cirinya, ada diare berulang dan penurunan berat badan perlahan.',
      audioPath: 'sounds/vo/sign3.mp3',
    ),
    const EducationSlide(
      title: 'Tanda & Gejala (4/4)',
      content:
          'Yang terakhir, AIDS. Tahap lanjut dari infeksi virus HIV, kondisi ini terjadi ketika imun tubuh sudah sangat lemah. Virus dalam tubuh akan berkembang cepat dan menimbulkan berbagai gejala berat bahkan bisa menyebabkan kematian.\n\nJadi, jika sudah merasa memiliki tanda-tanda seperti yang sudah dijelaskan.. Yuk periksa dan kendalikan! Banyak orang dengan HIV bisa hidup sehat dengan pengobatan dan kontrol rutin.',
      audioPath: 'sounds/vo/penanganan.mp3',
    ),
    const EducationSlide(
      title: 'Penanganan',
      content:
          'HIV ditangani dengan konsumsi obat antiretroviral (ARV) secara rutin serta pemeriksaan kesehatan berkala untuk memantau kondisi dan menekan jumlah virus.',
      audioPath: 'sounds/vo/penanganan-2.mp3',
    ),
    const EducationSlide(
      title: 'Pencegahan',
      content:
          'HIV dapat dicegah dengan menggunakan kondom secara konsisten, tidak berbagi jarum suntik, melakukan tes HIV secara rutin, serta mengonsumsi obat pencegahan dan pengobatan (PrEP dan ARV) sesuai anjuran tenaga kesehatan. Perilaku seksual yang lebih aman dan akses layanan kesehatan yang tepat membantu menurunkan risiko penularan HIV.',
      audioPath: 'sounds/vo/pencegahan.mp3', // Placeholder
    ),
    // const EducationSlide(
    //   title: 'Pesan Penting',
    //   content: 'Imbauan dan pengingat akhir...',
    //   audioPath: 'sounds/edu_reminder.mp3', // Placeholder
    // ),
  ];

  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _leftPageController = PageController();
    _rightPageController = PageController();
    _playCurrentSlideAudio();

    _playerCompleteSubscription = _audioPlayer.onPlayerComplete.listen((event) {
      // Auto-advance after 2 seconds when audio completes
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // Always advance, including on last slide (goes to role selection)
          _nextSlide();
        }
      });
    });
  }

  @override
  void dispose() {
    _playerCompleteSubscription?.cancel();
    _leftPageController.dispose();
    _rightPageController.dispose();
    _audioPlayer.stop(); // Ensure audio stops when leaving screen
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCurrentSlideAudio() async {
    try {
      debugPrint('Playing slide audio: Index $_currentIndex');
      await _audioPlayer.stop();
      final slide = _slides[_currentIndex];
      debugPrint('Audio path: ${slide.audioPath}');

      // Reset duration first to clear previous animation state if needed
      if (mounted) {
        setState(() {
          _currentSlideDuration = null;
        });
      }

      if (slide.audioPath.isNotEmpty) {
        debugPrint('Setting source...');
        final source = AssetSource(slide.audioPath);

        // Load and get duration
        await _audioPlayer.setSource(source);
        final duration = await _audioPlayer.getDuration();
        debugPrint('Duration found: $duration');

        if (mounted) {
          setState(() {
            _currentSlideDuration = duration;
          });
          debugPrint('Resuming player...');
          await _audioPlayer.resume();
        }
      } else {
        debugPrint('Audio path is empty');
      }
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      const duration = Duration(milliseconds: 500);
      const curve = Curves.easeInOut;
      _leftPageController.nextPage(duration: duration, curve: curve);
      _rightPageController.nextPage(duration: duration, curve: curve);
    } else {
      // Finished
      final controller = context.read<AppController>();
      controller.startRoleSelection();
    }
  }

  void _previousSlide() {
    if (_currentIndex > 0) {
      const duration = Duration(milliseconds: 500);
      const curve = Curves.easeInOut;
      _leftPageController.previousPage(duration: duration, curve: curve);
      _rightPageController.previousPage(duration: duration, curve: curve);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    _playCurrentSlideAudio();
  }

  @override
  Widget build(BuildContext context) {
    // Determine background based on slide index for variety (optional)
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: VRSplitter(
          builder: (context, eyeIndex) {
            return Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.cosmicBackground,
              ),
              child: SafeArea(
                child: Center(
                  child: Transform.scale(
                    scale: 0.65, // Simulates distance (1.5m - 3.0m feel)
                    child: _FinalEducationContent(
                      pageController: eyeIndex == 0
                          ? _leftPageController
                          : _rightPageController,
                      currentIndex: _currentIndex,
                      slides: _slides,
                      currentSlideDuration: _currentSlideDuration,
                      onPageChanged: _onPageChanged,
                      onNext: _nextSlide,
                      onPrevious: _previousSlide,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FinalEducationContent extends StatelessWidget {
  final PageController pageController;
  final int currentIndex;
  final List<EducationSlide> slides;
  final Duration? currentSlideDuration;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _FinalEducationContent({
    Key? key,
    required this.pageController,
    required this.currentIndex,
    required this.slides,
    required this.currentSlideDuration,
    required this.onPageChanged,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header / Progress
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            'Edukasi HIV/AIDS (${currentIndex + 1}/${slides.length})',
            style: AppTextStyles.bodyText.copyWith(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),

        // Slide Content
        Expanded(
          child: PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: slides.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              return _buildSlide(slides[index]);
            },
          ),
        ),

        // Navigation Controls
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              // Back Button (Always takes left side space)
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: currentIndex > 0
                      ? _buildNavButton(
                          icon: Icons.arrow_back,
                          label: 'Kembali',
                          onPressed: onPrevious,
                          color: AppColors.secondary,
                        )
                      : const SizedBox.shrink(),
                ),
              ),

              // Next / Finish Button (Always takes right side space)
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _buildNavButton(
                    icon: currentIndex == slides.length - 1
                        ? Icons.check_circle
                        : Icons.arrow_forward,
                    label: currentIndex == slides.length - 1
                        ? 'Selesai'
                        : 'Lanjut',
                    onPressed: onNext,
                    color: currentIndex == slides.length - 1
                        ? AppColors.success
                        : AppColors.primary,
                    isPrimary: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSlide(EducationSlide slide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
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
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Container(
                  height: 1.5,
                  width: 40,
                  color: AppColors.accent,
                ),
                const SizedBox(height: 8),
                _FadingText(
                  key: ValueKey('${slide.title}_$currentSlideDuration'),
                  text: slide.content,
                  duration: currentSlideDuration,
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
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? color : AppColors.secondary,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
