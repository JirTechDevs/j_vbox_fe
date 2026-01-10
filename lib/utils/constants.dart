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

/// Text styles
class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyText = TextStyle(
    fontSize: 18,
    color: AppColors.textSecondary,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
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
