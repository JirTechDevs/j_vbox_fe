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
                        shadows: [
                          Shadow(
                            color: AppColors.success,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Stay Informed, Stay Safe',
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
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.buttonRadius),
                          border:
                              Border.all(color: AppColors.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              soundManager.playButtonPress();
                              controller.goToMainMenu();
                            },
                            borderRadius: BorderRadius.circular(
                                AppDimensions.buttonRadius),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.replay,
                                    size: 32, color: AppColors.primary),
                                const SizedBox(width: 12),
                                Text(
                                  'RESTART',
                                  style: AppTextStyles.buttonText.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 22,
                                    shadows: [
                                      const Shadow(
                                          color: AppColors.primary,
                                          blurRadius: 8),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 32,
            shadows: const [Shadow(color: AppColors.primary, blurRadius: 8)],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading.copyWith(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
