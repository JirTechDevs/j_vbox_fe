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
                    'Pilihan Keputusan',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Risky behavior option (Red)
                      _buildBehaviorButton(
                        context,
                        controller,
                        soundManager,
                        label: 'Tidak Pakai Pengaman',
                        behavior: BehaviorType.risky,
                        icon: Icons.warning_amber_rounded,
                        color: AppColors.alertRed,
                      ),

                      const SizedBox(width: 48),

                      // Safe behavior option (Green)
                      _buildBehaviorButton(
                        context,
                        controller,
                        soundManager,
                        label: 'Pakai Pengaman',
                        behavior: BehaviorType.safe,
                        icon: Icons.shield,
                        color: AppColors.safetyGreen,
                      ),
                    ],
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
    required Color color,
  }) {
    return Container(
      width: 250,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2), // Neon border
        boxShadow: [
          // Multiple shadows for neon glow effect
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ), // Inner/Tight glow
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 24,
            spreadRadius: 4,
          ), // Outer/Soft glow
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            soundManager.playButtonPress();
            controller.selectBehavior(behavior);
          },
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with glow
              Icon(
                icon,
                size: 80,
                color: color,
                shadows: [
                  Shadow(color: color, blurRadius: 15),
                  Shadow(color: color, blurRadius: 30),
                ],
              ),
              const SizedBox(height: 24),
              // Text container with glow
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: AppTextStyles.buttonText.copyWith(
                    fontSize: 18, // Slightly smaller text for longer label
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
