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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                  color: AppColors.danger,
                  icon: Icons.warning,
                ),

                const SizedBox(height: 24),

                // NO - Stop risky behavior
                _buildDecisionButton(
                  context,
                  controller,
                  soundManager,
                  label: 'NO',
                  continueRisky: false,
                  color: AppColors.success,
                  icon: Icons.check_circle,
                ),
              ],
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
    required Color color,
    required IconData icon,
  }) {
    return SizedBox(
      width: AppDimensions.buttonWidth,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          soundManager.playButtonPress();
          controller.makeDecision(continueRisky);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTextStyles.buttonText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
