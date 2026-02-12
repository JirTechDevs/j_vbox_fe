import '../widgets/vr_splitter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../models/app_enums.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 2 - Behavior Selection Screen
/// Each eye shows ONLY its corresponding option
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
        body: VRSplitter(
          builder: (context, eyeIndex) {
            // Left eye (0) = Beresiko ONLY
            // Right eye (1) = Aman ONLY
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
                          'Pilihan Keputusan',
                          style: AppTextStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 64),

                        // Show ONLY the icon for this eye
                        GestureDetector(
                          onTap: () {
                            soundManager.playButtonPress();
                            controller.selectBehavior(
                              isLeftEye
                                  ? BehaviorType.risky
                                  : BehaviorType.safe,
                            );
                          },
                          child: SizedBox(
                            width: 280,
                            height: 220,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                isLeftEye
                                    ? 'assets/images/ic-behave-1-re.png'
                                    : 'assets/images/ic-behave-2-re.png',
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
