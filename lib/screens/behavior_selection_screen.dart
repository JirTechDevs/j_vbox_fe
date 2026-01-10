import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/app_enums.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 2 - Behavior Selection Screen
/// User selects behavior type: Risky or Safe
class BehaviorSelectionScreen extends StatelessWidget {
  const BehaviorSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final soundManager = SoundManager();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Choose Behavior',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Role context
              Text(
                'As ${controller.getRoleDisplayName()}',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),

              // Risky behavior option
              _buildBehaviorButton(
                context,
                controller,
                soundManager,
                label: 'Risky Behavior',
                behavior: BehaviorType.risky,
                icon: Icons.warning,
                color: AppColors.danger,
              ),

              const SizedBox(height: 24),

              // Safe behavior option
              _buildBehaviorButton(
                context,
                controller,
                soundManager,
                label: 'Safe Behavior',
                behavior: BehaviorType.safe,
                icon: Icons.health_and_safety,
                color: AppColors.success,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBehaviorButton(
    BuildContext context,
    AppController controller,
    SoundManager soundManager, {
    required String label,
    required BehaviorType behavior,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: AppDimensions.buttonWidth,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          soundManager.playButtonPress();
          controller.selectBehavior(behavior);
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
