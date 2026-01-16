import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

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
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  @override
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
            },
            children: [
              _buildDisclaimerPage(),
              _buildDefinitionPage(),
              _buildPreventionPage(),
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

  Widget _buildDefinitionPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Apa itu HIV?',
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
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildDefinitionItem('Human', 'Manusia')),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: _buildDefinitionItem('Immunodeficiency',
                            'Penurunan sistem kekebalan tubuh'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDefinitionItem('Virus', 'Virus')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.secondary),
                  const SizedBox(height: 16),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: AppTextStyles.bodyText.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      children: const [
                        TextSpan(text: 'Artinya, '),
                        TextSpan(
                          text: 'Human Immunodeficiency Virus (HIV)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                        TextSpan(
                            text:
                                ' adalah virus yang menyerang manusia dan menyebabkan penurunan sistem kekebalan tubuh, sehingga rentan terhadap penyakit.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreventionPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pencegahan (ABCDE)',
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
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreventionItem('A', 'Abstinence',
                      'Tidak melakukan hubungan seks (bagi yang belum menikah).'),
                  const SizedBox(height: 10),
                  _buildPreventionItem(
                      'B', 'Be Faithful', 'Saling setia pada satu pasangan.'),
                  const SizedBox(height: 10),
                  _buildPreventionItem('C', 'Condom',
                      'Gunakan kondom jika berhubungan seks berisiko.'),
                  const SizedBox(height: 10),
                  _buildPreventionItem('D', 'Don\'t Use Drugs',
                      'Hindari penggunaan narkoba, terutama suntik.'),
                  const SizedBox(height: 10),
                  _buildPreventionItem('E', 'Education',
                      'Cari informasi yang benar tentang HIV/AIDS.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefinitionItem(String term, String definition) {
    return Column(
      children: [
        Text(
          term,
          style: AppTextStyles.heading.copyWith(
            color: AppColors.primary,
            fontSize: 18,
            shadows: [
              const Shadow(color: AppColors.primary, blurRadius: 4),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          definition,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPreventionItem(String letter, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$letter. ',
          style: AppTextStyles.heading.copyWith(
            color: AppColors.primary,
            fontSize: 18,
            shadows: [const Shadow(color: AppColors.primary, blurRadius: 4)],
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyText.copyWith(
                color: Colors.white,
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
                TextSpan(text: desc),
              ],
            ),
          ),
        ),
      ],
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

  const _FadingText({
    Key? key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: words.length * 80 + 1000),
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
