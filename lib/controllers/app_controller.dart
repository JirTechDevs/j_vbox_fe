import 'package:flutter/services.dart';
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

  /// Private method to update screen orientation based on state
  void _updateOrientation() {
    // VR states require landscape
    if (_currentState == AppState.vrTimeLapse ||
        _currentState == AppState.vrNegativeOutcome ||
        _currentState == AppState.vrRecovery) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Menu and text-heavy screens use portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  /// Navigate to main menu (reset state)
  void goToMainMenu() {
    _currentState = AppState.mainMenu;
    _selectedRole = null;
    _selectedBehavior = null;
    _isHealthy = null;
    _continueRiskyBehavior = null;
    _updateOrientation();
    notifyListeners();
  }

  /// Start scenario - go to information screen
  void startScenario() {
    _currentState = AppState.information;
    _updateOrientation();
    notifyListeners();
  }

  /// Proceed from information to role selection
  void proceedFromInformation() {
    _currentState = AppState.roleSelection;
    _updateOrientation();
    notifyListeners();
  }

  /// Select user role and proceed to behavior selection
  void selectRole(UserRole role) {
    _selectedRole = role;
    _currentState = AppState.behaviorSelection;
    _updateOrientation();
    notifyListeners();
  }

  /// Select behavior and proceed to VR time lapse
  void selectBehavior(BehaviorType behavior) {
    _selectedBehavior = behavior;
    _currentState = AppState.vrTimeLapse;
    _updateOrientation();
    notifyListeners();
  }

  /// Complete VR time lapse and determine health result
  void completeTimeLapse() {
    // Determine health based on behavior
    _isHealthy = _selectedBehavior == BehaviorType.safe;
    _currentState = AppState.healthResult;
    _updateOrientation();
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
    _updateOrientation();
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
    _updateOrientation();
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
    _updateOrientation();
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

  /// Handle back navigation
  void goBack() {
    switch (_currentState) {
      case AppState.information:
        _currentState = AppState.mainMenu;
        break;
      case AppState.roleSelection:
        _currentState = AppState.information;
        break;
      case AppState.behaviorSelection:
        _selectedRole = null; // Clear role selection
        _currentState = AppState.roleSelection;
        break;
      case AppState.decision:
        _selectedBehavior = null; // Clear behavior selection
        _currentState = AppState.behaviorSelection;
        break;
      default:
        // For other states (like during VR or final result),
        // we might not want to allow simple back navigation or handle it differently
        break;
    }
    _updateOrientation();
    notifyListeners();
  }

  /// Get role display name
  String getRoleDisplayName() {
    if (_selectedRole == null) return '';
    return _selectedRole == UserRole.gay
        ? 'Laki-laki'
        : 'Perempuan'; // Replaced PSK for universal appeal
  }

  /// Get behavior display name
  String getBehaviorDisplayName() {
    if (_selectedBehavior == null) return '';
    return _selectedBehavior == BehaviorType.risky
        ? 'Tanpa Pengaman'
        : 'Pakai Pengaman'; // Replaced Kondom
  }
}
