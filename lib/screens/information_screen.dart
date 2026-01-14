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
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Apa itu HIV?',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Content Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildDefinitionItem('Human', 'Manusia'),
                        const SizedBox(height: 16),
                        _buildDefinitionItem('Immunodeficiency',
                            'Kelemahan atau kerusakan\nsistem kekebalan tubuh'),
                        const SizedBox(height: 16),
                        _buildDefinitionItem('Virus', 'Virus'),
                        const SizedBox(height: 24),
                        const Divider(color: AppColors.secondary),
                        const SizedBox(height: 24),
                        RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: AppTextStyles.bodyText.copyWith(
                              fontSize: 16,
                              color: AppColors.textPrimary,
                            ),
                            children: const [
                              TextSpan(text: 'Artinya, '),
                              TextSpan(
                                text: 'Human Immunodeficiency Virus (HIV)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                  text:
                                      ' adalah virus yang menyerang manusia dan menyebabkan kelemahan atau kerusakan sistem kekebalan tubuh, sehingga tubuh menjadi lebih rentan terhadap berbagai infeksi dan penyakit.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Lanjutkan Button
                  Container(
                    width: AppDimensions.buttonWidth,
                    height: AppDimensions.buttonHeight,
                    decoration: BoxDecoration(
                      gradient: AppGradients.primaryButton,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.buttonRadius),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        soundManager.playButtonPress();
                        controller.proceedFromInformation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.buttonRadius),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'LANJUTKAN',
                            style: AppTextStyles.buttonText,
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.arrow_forward, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          definition,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
