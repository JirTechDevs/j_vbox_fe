import 'package:flutter/material.dart';

/// Application colors - VR-friendly palette
class AppColors {
  // Dark theme for VR comfort
  static const Color background = Color(0xFF0A0E27);
  static const Color surface = Color(0xFF1A1F3A);
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color accent = Color(0xFFFF6B9D);
  static const Color success = Color(0xFF45B7D1);
  static const Color warning = Color(0xFFFFA07A);
  static const Color danger = Color(0xFFFF6B6B);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8D1);
}

/// Application Gradients
class AppGradients {
  /// Universal Cosmic Background (Deep Purple -> Navy)
  /// Neutral for both genders, not empty like black
  static const LinearGradient cosmicBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2E1C59), // Deep Purple
      Color(0xFF0F1229), // Rich Navy
    ],
  );

  /// Primary Button Gradient (Purple -> Blue)
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF6C63FF), Color(0xFF4834D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary Button Gradient (Teal -> Emerald for Safe)
  static const LinearGradient safeButton = LinearGradient(
    colors: [Color(0xFF4ECDC4), Color(0xFF26DE81)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Danger/Risky Button Gradient (Bright Red -> Deep Crimson)
  static const LinearGradient riskyButton = LinearGradient(
    colors: [Color(0xFFFF5252), Color(0xFFD50000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Pink/Magenta Button Gradient (Feminine Role)
  static const LinearGradient pinkButton = LinearGradient(
    colors: [Color(0xFFE91E63), Color(0xFFFF4081)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Neutral Button Gradient (Greyish)
  static const LinearGradient neutralButton = LinearGradient(
    colors: [Color(0xFF485460), Color(0xFF1E272E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Text styles
class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        blurRadius: 10.0,
        color: Colors.black54,
        offset: Offset(2.0, 2.0),
      ),
    ],
    letterSpacing: 1.2,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        blurRadius: 4.0,
        color: Colors.black45,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );

  static const TextStyle buttonTextBehaviour = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        blurRadius: 4.0,
        color: Colors.black45,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 18,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );
}

/// Button dimensions
class AppDimensions {
  static const double buttonHeight = 80.0;
  static const double buttonWidth = 300.0;
  static const double buttonRadius = 16.0;
  static const double spacing = 24.0;
}

/// Video paths mapping
class VideoAssets {
  static const Map<String, String> videos = {
    'gay_risky': 'assets/videos/gay_risky.mp4',
    'gay_safe': 'assets/videos/gay_safe.mp4',
    'psk_risky': 'assets/videos/psk_risky.mp4',
    'psk_safe': 'assets/videos/psk_safe.mp4',
    'positive_end': 'assets/videos/positive_end.mp4',
    'recovery': 'assets/videos/recovery.mp4',
  };

  /// Get video path based on role and behavior
  static String getVideoPath(String role, String behavior) {
    final key = '${role}_$behavior';
    return videos[key] ?? '';
  }

  /// Get outcome video path
  static String getOutcomeVideo(bool continueRisky) {
    return continueRisky ? videos['positive_end']! : videos['recovery']!;
  }
}

/// Sound assets
class SoundAssets {
  static const String buttonPress = 'sounds/button_press.mp3';
}
