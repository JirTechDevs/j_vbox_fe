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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.cosmicBackground,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Title
                  const Icon(
                    Icons.health_and_safety,
                    size: 100,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 16),

                  // App Title
                  Text(
                    'Simulasi Virtual Edukasi HIV/AIDS',
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.primary,
                      shadows: [
                        const Shadow(
                          color: AppColors.primary,
                          blurRadius: 10,
                        ),
                        const Shadow(
                          color: AppColors.primary,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Siap masuk ke dunia yang berbeda? Ayo lihat pengalaman Virtual Reality sekarang!',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Play Button
                  _buildPlayButton(context, controller, soundManager),

                  const SizedBox(height: 24),
                ],
              ),
            ),
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
    final color = AppColors.primary;
    return Container(
      width: AppDimensions.buttonWidth + 50,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
        border: Border.all(color: color, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 8,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            soundManager.playButtonPress();
            controller.startScenario();
          },
          borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow,
                size: 40,
                color: color,
                shadows: [
                  Shadow(color: color, blurRadius: 15),
                  Shadow(color: color, blurRadius: 30),
                ],
              ),
              const SizedBox(width: 12),
              Text(
                'MULAI PERJALANAN',
                style: AppTextStyles.buttonText.copyWith(
                  color: color,
                  fontSize: 22,
                  shadows: [
                    Shadow(color: color, blurRadius: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
