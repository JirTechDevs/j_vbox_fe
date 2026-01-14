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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Pilih Tindakan',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Role context
                  Text(
                    'Sebagai ${controller.getRoleDisplayName()}',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),

                  // Safe behavior option
                  _buildBehaviorButton(
                    context,
                    controller,
                    soundManager,
                    label: 'Pakai Pengaman',
                    behavior: BehaviorType.safe,
                    icon: Icons.health_and_safety,
                    gradient: AppGradients.safeButton,
                  ),

                  const SizedBox(height: 24),

                  // Risky behavior option
                  _buildBehaviorButton(
                    context,
                    controller,
                    soundManager,
                    label: 'Tanpa Pengaman',
                    behavior: BehaviorType.risky,
                    icon: Icons.warning,
                    gradient: AppGradients.riskyButton,
                  ),
                ],
              ),
            ),
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
    required Gradient gradient,
  }) {
    return Container(
      width: AppDimensions.buttonWidth,
      height: AppDimensions.buttonHeight,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          soundManager.playButtonPress();
          controller.selectBehavior(behavior);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.buttonTextBehaviour,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
