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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              const Text(
                'Select Your Role',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),

              // Gay option
              _buildRoleButton(
                context,
                controller,
                soundManager,
                label: 'Gay',
                role: UserRole.gay,
                icon: Icons.person,
                color: AppColors.primary,
              ),

              const SizedBox(height: 24),

              // PSK option
              _buildRoleButton(
                context,
                controller,
                soundManager,
                label: 'Sex Worker (PSK)',
                role: UserRole.psk,
                icon: Icons.person_outline,
                color: AppColors.secondary,
              ),
            ],
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
    return SizedBox(
      width: AppDimensions.buttonWidth,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          soundManager.playButtonPress();
          controller.selectRole(role);
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
