import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 7 - Final Education Screen
/// Prevention message and closing screen
/// Allows user to restart or exit
class FinalEducationScreen extends StatelessWidget {
  const FinalEducationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final soundManager = SoundManager();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        controller
            .goBack(); // Will allow exit or restart from here depending on logic
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppGradients.cosmicBackground,
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success Icon
                      const Icon(
                        Icons.school,
                        size: 100,
                        color: AppColors.success,
                      ),
                      const SizedBox(height: 32),

                      // Title
                      const Text(
                        'Stay Informed, Stay Safe',
                        style: AppTextStyles.title,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // Educational Content
                      _buildEducationSection(
                        icon: Icons.info_outline,
                        title: 'Prevention is Key',
                        content:
                            'Use protection consistently, get tested regularly, and know your status.',
                      ),
                      const SizedBox(height: 24),

                      _buildEducationSection(
                        icon: Icons.favorite,
                        title: 'Treatment is Available',
                        content:
                            'Early detection and antiretroviral therapy (ART) can help people with HIV live long, healthy lives.',
                      ),
                      const SizedBox(height: 24),

                      _buildEducationSection(
                        icon: Icons.people,
                        title: 'Support Exists',
                        content:
                            'Reach out to healthcare providers, support groups, and community organizations for help.',
                      ),
                      const SizedBox(height: 48),

                      // Action Buttons
                      Container(
                        width: AppDimensions.buttonWidth,
                        height: AppDimensions.buttonHeight,
                        decoration: BoxDecoration(
                          gradient: AppGradients.primaryButton,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.buttonRadius),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            soundManager.playButtonPress();
                            controller.goToMainMenu();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppColors.textPrimary,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.buttonRadius),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.replay, size: 28, color: Colors.white),
                              SizedBox(width: 12),
                              Text(
                                'RESTART',
                                style: AppTextStyles.buttonText,
                              ),
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
        ),
      ),
    );
  }

  Widget _buildEducationSection({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.secondary,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: AppTextStyles.bodyText.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
