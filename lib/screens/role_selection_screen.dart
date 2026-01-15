import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/app_enums.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 1 - Role Selection Screen
/// User selects their role: Gay or Sex Worker (PSK)
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final soundManager = SoundManager();

    return PopScope(
      canPop: false, // Prevent default pop
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
                    'Pilihan Perspektif',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Laki-laki option (Gay - Cyan)
                      _buildRoleButton(
                        context,
                        controller,
                        soundManager,
                        label: 'Laki-laki',
                        role: UserRole.gay,
                        icon: Icons.man,
                        color: AppColors.electricCyan,
                      ),

                      const SizedBox(width: 48),

                      // Perempuan option (PSK - Magenta)
                      _buildRoleButton(
                        context,
                        controller,
                        soundManager,
                        label: 'Perempuan',
                        role: UserRole.psk,
                        icon: Icons.woman,
                        color: AppColors.hotMagenta,
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

  Widget _buildRoleButton(
    BuildContext context,
    AppController controller,
    SoundManager soundManager, {
    required String label,
    required UserRole role,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 250, // Slightly smaller for landscape row
      height: 200, // Taller for card look
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6), // Dark background for contrast
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
            controller.selectRole(role);
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
                    fontSize: 20,
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
