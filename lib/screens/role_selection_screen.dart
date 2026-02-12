import '../widgets/vr_splitter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/app_enums.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 1 - Role Selection Screen
/// Each eye shows ONLY its corresponding option
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

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
        body: VRSplitter(
          builder: (context, eyeIndex) {
            // Left eye (0) = Laki-laki ONLY
            // Right eye (1) = Perempuan ONLY
            final isLeftEye = eyeIndex == 0;

            return Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.cosmicBackground,
              ),
              child: SafeArea(
                child: Center(
                  child: Transform.scale(
                    scale: 0.75,
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

                        // Show ONLY the icon for this eye
                        GestureDetector(
                          onTap: () {
                            soundManager.playButtonPress();
                            controller.selectRole(
                              isLeftEye ? UserRole.gay : UserRole.psk,
                            );
                          },
                          child: SizedBox(
                            width: 280,
                            height: 220,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                isLeftEye
                                    ? 'assets/images/ic-role-1.png'
                                    : 'assets/images/ic-role-2.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
