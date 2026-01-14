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
                    'Pilih Peran',
                    style: AppTextStyles.title,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),

                  // Laki-laki option
                  _buildRoleButton(
                    context,
                    controller,
                    soundManager,
                    label: 'Laki-laki',
                    role: UserRole.gay,
                    icon: Icons.man, // Changed to silhouette
                    gradient: AppGradients.primaryButton,
                  ),

                  const SizedBox(height: 24),

                  // Perempuan option
                  _buildRoleButton(
                    context,
                    controller,
                    soundManager,
                    label: 'Perempuan',
                    role: UserRole.psk,
                    icon: Icons.woman, // Changed to silhouette
                    gradient: AppGradients.pinkButton,
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
          controller.selectRole(role);
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
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: AppTextStyles.buttonText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
