import 'package:flutter/material.dart';
import '../models/app_enums.dart';
import '../utils/constants.dart';

/// Central application controller for state management
/// Uses ChangeNotifier for simple, reactive state updates
class AppController extends ChangeNotifier {
  // Current application state
  AppState _currentState = AppState.mainMenu;

  // User selections
  UserRole? _selectedRole;
  BehaviorType? _selectedBehavior;
  bool? _isHealthy; // null = not determined, true = healthy, false = HIV+
  bool? _continueRiskyBehavior; // Only relevant if HIV+

  // Getters
  AppState get currentState => _currentState;
  UserRole? get selectedRole => _selectedRole;
  BehaviorType? get selectedBehavior => _selectedBehavior;
  bool? get isHealthy => _isHealthy;
  bool? get continueRiskyBehavior => _continueRiskyBehavior;

  /// Navigate to main menu (reset state)
  void goToMainMenu() {
    _currentState = AppState.mainMenu;
    _selectedRole = null;
    _selectedBehavior = null;
    _isHealthy = null;
    _continueRiskyBehavior = null;
    notifyListeners();
  }

  /// Start scenario - go to role selection
  void startScenario() {
    _currentState = AppState.roleSelection;
    notifyListeners();
  }

  /// Select user role and proceed to behavior selection
  void selectRole(UserRole role) {
    _selectedRole = role;
    _currentState = AppState.behaviorSelection;
    notifyListeners();
  }

  /// Select behavior and proceed to VR time lapse
  void selectBehavior(BehaviorType behavior) {
    _selectedBehavior = behavior;
    _currentState = AppState.vrTimeLapse;
    notifyListeners();
  }

  /// Complete VR time lapse and determine health result
  void completeTimeLapse() {
    // Determine health based on behavior
    _isHealthy = _selectedBehavior == BehaviorType.safe;
    _currentState = AppState.healthResult;
    notifyListeners();
  }

  /// Continue from health result
  void proceedFromHealthResult() {
    if (_isHealthy == true) {
      // Safe behavior → go to final education
      _currentState = AppState.finalEducation;
    } else {
      // Risky behavior (HIV+) → go to decision screen
      _currentState = AppState.decision;
    }
    notifyListeners();
  }

  /// Make decision on continuing risky behavior
  void makeDecision(bool continueRisky) {
    _continueRiskyBehavior = continueRisky;

    if (continueRisky) {
      // Continue risky → negative outcome (death)
      _currentState = AppState.vrNegativeOutcome;
    } else {
      // Stop risky → recovery path
      _currentState = AppState.vrRecovery;
    }
    notifyListeners();
  }

  /// Complete negative outcome VR
  void completeNegativeOutcome() {
    // Go back to main menu (app ends, can restart)
    goToMainMenu();
  }

  /// Complete recovery VR
  void completeRecovery() {
    // Proceed to final education
    _currentState = AppState.finalEducation;
    notifyListeners();
  }

  /// Get the appropriate video path for time lapse
  String getTimeLapseVideoPath() {
    if (_selectedRole == null || _selectedBehavior == null) {
      return '';
    }

    final role = _selectedRole == UserRole.gay ? 'gay' : 'psk';
    final behavior = _selectedBehavior == BehaviorType.risky ? 'risky' : 'safe';

    return VideoAssets.getVideoPath(role, behavior);
  }

  /// Get the appropriate outcome video path
  String getOutcomeVideoPath() {
    if (_continueRiskyBehavior == null) {
      return '';
    }

    return VideoAssets.getOutcomeVideo(_continueRiskyBehavior!);
  }

  /// Get role display name
  String getRoleDisplayName() {
    if (_selectedRole == null) return '';
    return _selectedRole == UserRole.gay ? 'Gay' : 'Sex Worker (PSK)';
  }

  /// Get behavior display name
  String getBehaviorDisplayName() {
    if (_selectedBehavior == null) return '';
    return _selectedBehavior == BehaviorType.risky
        ? 'Risky Behavior'
        : 'Safe Behavior';
  }
}
