import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'controllers/app_controller.dart';
import 'models/app_enums.dart';
import 'screens/main_menu_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/behavior_selection_screen.dart';
import 'screens/vr_time_lapse_screen.dart';
import 'screens/health_result_screen.dart';
import 'screens/decision_screen.dart';
import 'screens/vr_negative_outcome_screen.dart';
import 'screens/vr_recovery_screen.dart';
import 'screens/final_education_screen.dart';
import 'utils/constants.dart';
import 'utils/sound_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize with Portrait for the menu
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize sound manager
  await SoundManager().initialize();

  runApp(const VRBoxApp());
}

class VRBoxApp extends StatelessWidget {
  const VRBoxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppController(),
      child: MaterialApp(
        title: 'VR Box Education',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            background: AppColors.background,
          ),
          textTheme: const TextTheme(
            displayLarge: AppTextStyles.title,
            headlineMedium: AppTextStyles.heading,
            bodyLarge: AppTextStyles.bodyText,
          ),
        ),
        home: const AppNavigator(),
      ),
    );
  }
}

/// Main navigator that switches screens based on AppState
class AppNavigator extends StatelessWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, controller, _) {
        // Route to appropriate screen based on current state
        switch (controller.currentState) {
          case AppState.mainMenu:
            return const MainMenuScreen();

          case AppState.roleSelection:
            return const RoleSelectionScreen();

          case AppState.behaviorSelection:
            return const BehaviorSelectionScreen();

          case AppState.vrTimeLapse:
            return const VRTimeLapseScreen();

          case AppState.healthResult:
            return const HealthResultScreen();

          case AppState.decision:
            return const DecisionScreen();

          case AppState.vrNegativeOutcome:
            return const VRNegativeOutcomeScreen();

          case AppState.vrRecovery:
            return const VRRecoveryScreen();

          case AppState.finalEducation:
            return const FinalEducationScreen();
        }
      },
    );
  }
}
