import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 4 - Health Result Screen
/// Displays health outcome based on behavior choice
/// Risky → HIV Positive, Safe → Healthy
class HealthResultScreen extends StatelessWidget {
  const HealthResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final soundManager = SoundManager();
    final isHealthy = controller.isHealthy ?? true;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.cosmicBackground,
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Result Icon
                  Icon(
                    isHealthy ? Icons.check_circle : Icons.cancel,
                    size: 120,
                    color: isHealthy ? AppColors.success : AppColors.danger,
                    shadows: [
                      Shadow(
                        color:
                            (isHealthy ? AppColors.success : AppColors.danger)
                                .withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                      Shadow(
                        color:
                            (isHealthy ? AppColors.success : AppColors.danger)
                                .withOpacity(0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Result Title
                  Text(
                    isHealthy ? 'Healthy!' : 'HIV Positive',
                    style: AppTextStyles.title.copyWith(
                      color: isHealthy ? AppColors.success : AppColors.danger,
                      fontSize: 40,
                      shadows: [
                        Shadow(
                          color:
                              (isHealthy ? AppColors.success : AppColors.danger)
                                  .withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Result Message
                  Text(
                    isHealthy
                        ? 'Your safe behavior choices have kept you healthy. Continue practicing safe habits!'
                        : 'Your risky behavior choices have led to HIV infection. Early detection and treatment are crucial.',
                    style: AppTextStyles.bodyText.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Context
                  Text(
                    'Role: ${controller.getRoleDisplayName()}\nBehavior: ${controller.getBehaviorDisplayName()}',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),

                  // Continue Button
                  Container(
                    width: AppDimensions.buttonWidth,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.buttonRadius),
                      border: Border.all(color: AppColors.primary, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          soundManager.playButtonPress();
                          controller.proceedFromHealthResult();
                        },
                        borderRadius:
                            BorderRadius.circular(AppDimensions.buttonRadius),
                        child: Center(
                          child: Text(
                            'CONTINUE',
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColors.primary,
                              fontSize: 22,
                              shadows: [
                                const Shadow(
                                  color: AppColors.primary,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
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
    );
  }
}
