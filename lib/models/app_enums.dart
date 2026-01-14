/// Application state enumeration
/// Represents the 8 states of the application flow
enum AppState {
  mainMenu, // State 0: Main menu with play button
  information, // State 0.5: HIV Information Screen
  roleSelection, // State 1: Select Gay or PSK
  behaviorSelection, // State 2: Select Risky or Safe behavior
  vrTimeLapse, // State 3: VR mode - 5 year time lapse
  healthResult, // State 4: Display health outcome
  decision, // State 5: Decision screen (HIV+ only)
  vrNegativeOutcome, // State 6A: VR mode - negative outcome (death)
  vrRecovery, // State 6B: VR mode - recovery path
  finalEducation, // State 7: Final education message
}

/// User role selection
enum UserRole {
  gay, // Gay community
  psk, // Sex Worker (Pekerja Seks Komersial)
}

/// Behavior type selection
enum BehaviorType {
  risky, // Risky behavior
  safe, // Safe behavior
}
