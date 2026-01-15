import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 5 - Decision Screen
/// Only shown if HIV positive
/// User decides whether to continue risky behavior
class DecisionScreen extends StatelessWidget {
  const DecisionScreen({Key? key}) : super(key: key);

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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Warning Icon
                    const Icon(
                      Icons.help_outline,
                      size: 100,
                      color: AppColors.warning,
                    ),
                    const SizedBox(height: 32),

                    // Question
                    const Text(
                      'Critical Decision',
                      style: AppTextStyles.title,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Continue risky behavior?',
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'This decision will determine your future health outcome.',
                      style: AppTextStyles.bodyText,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 64),

                    // YES - Continue risky behavior
                    _buildDecisionButton(
                      context,
                      controller,
                      soundManager,
                      label: 'YES',
                      continueRisky: true,
                      icon: Icons.warning,
                      gradient: AppGradients.riskyButton,
                    ),

                    const SizedBox(height: 24),

                    // NO - Stop risky behavior
                    _buildDecisionButton(
                      context,
                      controller,
                      soundManager,
                      label: 'NO',
                      continueRisky: false,
                      icon: Icons.check_circle,
                      gradient: AppGradients.safeButton,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecisionButton(
    BuildContext context,
    AppController controller,
    SoundManager soundManager, {
    required String label,
    required bool continueRisky,
    required IconData icon,
    required Gradient gradient,
  }) {
    final color = continueRisky ? AppColors.alertRed : AppColors.safetyGreen;
    return Container(
      width: AppDimensions.buttonWidth,
      height: AppDimensions.buttonHeight,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: color.withOpacity(0.4),
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
            controller.makeDecision(continueRisky);
          },
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
                shadows: [
                  Shadow(color: color, blurRadius: 10),
                ],
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTextStyles.buttonText.copyWith(
                  color: color,
                  shadows: [
                    Shadow(color: color, blurRadius: 5),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
