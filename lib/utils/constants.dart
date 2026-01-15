import 'package:flutter/material.dart';

/// Application colors - Professional & Neutral Palette
class AppColors {
  // Dark theme for neon aesthetic
  static const Color background = Color(0xFF13092D); // Deep Space Violet
  static const Color surface = Color(0xFF2D124B); // Nebula Purple (lighter)
  static const Color primary =
      Color(0xFF00F0FF); // Electric Cyan (Neon Primary)
  static const Color secondary = Color(0xFF6C8EBF); // Muted Blue
  static const Color accent = Color(0xFFFF007F); // Hot Magenta
  static const Color success = Color(0xFF00FF51); // Safety Green
  static const Color warning = Color(0xFFFF2A2A); // Alert Red
  static const Color danger = Color(0xFFFF2A2A);
  static const Color textPrimary = Color(0xFFFFFFFF); // White for dark bg
  static const Color textSecondary =
      Color(0xFFB0C7D9); // Light Blue-Grey for secondary text

  // The Base (Background)
  static const Color deepSpaceViolet = Color(0xFF13092D); // The dark void
  static const Color nebulaPurple =
      Color(0xFF2D124B); // The lighter ambient background

  // Palette A (Image 1 - Relationships)
  static const Color electricCyan = Color(0xFF00F0FF); // Gay
  static const Color hotMagenta = Color(0xFFFF007F); // PSK

  // Palette B (Image 2 - Status/Action)
  static const Color alertRed = Color(0xFFFF2A2A); // Warning
  static const Color safetyGreen = Color(0xFF00FF51); // Safe
}

/// Application Gradients
class AppGradients {
  /// Universal Background (Warm Off-White)
  /// Kept as gradient for compatibility, but subtler
  static const LinearGradient cosmicBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.deepSpaceViolet, // The dark void
      AppColors.nebulaPurple, // The lighter ambient background
    ],
  );

  /// Primary Button Gradient (Soft Teal)
  static const LinearGradient primaryButton = LinearGradient(
    colors: [Color(0xFF4FA3A5), Color(0xFF42898B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Secondary Button Gradient (Muted Blue)
  static const LinearGradient secondaryButton = LinearGradient(
    colors: [Color(0xFF6C8EBF), Color(0xFF5A79A6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Safe Button Gradient (Soft Green)
  static const LinearGradient safeButton = LinearGradient(
    colors: [Color(0xFF6DBE8B), Color(0xFF5AA876)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Risky Button Gradient (Muted Coral Red)
  static const LinearGradient riskyButton = LinearGradient(
    colors: [Color(0xFFE07A5F), Color(0xFFC96D55)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Pink/Magenta Button Gradient (Feminine Role - Adjusted to Palette)
  /// Using a softer pink that harmonizes with the new palette
  static const LinearGradient pinkButton = LinearGradient(
    colors: [
      Color(0xFFE91E63),
      Color(0xFFC2185B)
    ], // Kept distinctly pink but slightly muted
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Neutral Button Gradient (Grey)
  static const LinearGradient neutralButton = LinearGradient(
    colors: [Color(0xFF95A5A6), Color(0xFF7F8C8D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Text styles
class AppTextStyles {
  // Font Family: Inter
  static const String fontFamily = 'Inter';

  static const TextStyle title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24, // Mobile-safe Headline (20-24sp)
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    shadows: [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black12,
        offset: Offset(1.0, 1.0),
      ),
    ],
    letterSpacing: 0.5,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18, // Button >= 16sp
    fontWeight: FontWeight.w600, // SemiBold
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black26,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );

  static const TextStyle buttonTextBehaviour = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16, // Button >= 16sp
    fontWeight: FontWeight.w500, // Medium
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 2.0,
        color: Colors.black26,
        offset: Offset(1.0, 1.0),
      ),
    ],
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16, // Body 14-16sp
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20, // Mobile-safe Headline (20-24sp)
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
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
