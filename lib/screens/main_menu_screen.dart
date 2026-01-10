import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 0 - Main Menu Screen
/// Entry point of the application
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

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
              // App Logo/Title
              const Icon(
                Icons.health_and_safety,
                size: 120,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),

              // App Title
              const Text(
                'VR Box Education',
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Subtitle
              Text(
                'HIV/AIDS Prevention',
                style: AppTextStyles.bodyText.copyWith(
                  color: AppColors.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),

              // Play Button
              _buildPlayButton(context, controller, soundManager),

              const SizedBox(height: 32),

              // Info text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Make choices that shape your future',
                  style: AppTextStyles.bodyText,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayButton(
    BuildContext context,
    AppController controller,
    SoundManager soundManager,
  ) {
    return SizedBox(
      width: AppDimensions.buttonWidth,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: () {
          soundManager.playButtonPress();
          controller.startScenario();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          ),
          elevation: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_arrow, size: 32),
            const SizedBox(width: 12),
            const Text(
              'PLAY',
              style: AppTextStyles.buttonText,
            ),
          ],
        ),
      ),
    );
  }
}
