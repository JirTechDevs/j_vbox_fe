# VR Box Education - HIV/AIDS Prevention App

A production-ready Flutter Android application for educational VR video playback using smartphone-based VR Box viewers.

## 📱 Overview

This offline educational app teaches HIV/AIDS prevention through choice-based video branching. Users make choices on a normal screen, then experience the consequences through VR video playback.

**Key Features:**
- ✅ State-based navigation (8 states)
- ✅ Offline-only (no backend, no networking)
- ✅ VR split-screen video playback
- ✅ No interaction inside VR mode
- ✅ Simple, production-ready architecture

## 🎯 User Flow

```
0. Main Menu → PLAY button
1. Role Selection → Gay or Sex Worker (PSK)
2. Behavior Selection → Risky or Safe
3. VR Mode: Time Lapse → 5 year video (auto-exit)
4. Health Result → HIV+ (risky) or Healthy (safe)
5. Decision (if HIV+) → Continue risky? YES/NO
6A. VR Mode: Negative Outcome → Death (auto-exit)
6B. VR Mode: Recovery → Education (auto-exit)
7. Final Education → Prevention message, restart option
```

## 📋 Requirements

- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher
- **Android**: Minimum SDK 21 (Android 5.0)
- **Device**: Android smartphone with landscape orientation support

## 🚀 Setup Instructions

### 1. Clone and Setup

```bash
cd /data/Projects/j_vbox_fe
# No need to run flutter create - already initialized
```

### 2. Install Dependencies

```bash
fvm flutter pub get
```

### 3. Add Video Assets

Place the following client-provided video files in `assets/videos/`:

- `gay_risky.mp4` - VR video for gay + risky behavior
- `gay_safe.mp4` - VR video for gay + safe behavior
- `psk_risky.mp4` - VR video for PSK + risky behavior
- `psk_safe.mp4` - VR video for PSK + safe behavior
- `positive_end.mp4` - VR video for negative outcome (death)
- `recovery.mp4` - VR video for recovery path

**Important**: All videos must be in MP4 format and optimized for VR viewing.

### 4. Add Sound Effect (Optional)

Place a button press sound file in `assets/sounds/button_press.mp3`

If you don't have a sound file, the app will work silently (sound failures are handled gracefully).

### 5. Run the App

```bash
# Debug mode
fvm flutter run

# Release mode (for testing)
fvm flutter run --release
```

## 📦 Build APK

### Debug APK

```bash
fvm flutter build apk --debug
```

### Release APK (Production)

```bash
fvm flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## 🏗️ Architecture

### State Management

Uses `ChangeNotifier` with `Provider` for simple, reactive state management.

**AppController** manages:
- Current application state (8 states)
- User selections (role, behavior)
- Health determination logic
- Video path resolution
- State transitions

### File Structure

```
lib/
├── main.dart                         # App entry point
├── models/
│   └── app_enums.dart               # AppState, UserRole, BehaviorType enums
├── controllers/
│   └── app_controller.dart          # Central state management
├── screens/                          # 9 screen widgets (normal + VR)
│   ├── main_menu_screen.dart
│   ├── role_selection_screen.dart
│   ├── behavior_selection_screen.dart
│   ├── vr_time_lapse_screen.dart
│   ├── health_result_screen.dart
│   ├── decision_screen.dart
│   ├── vr_negative_outcome_screen.dart
│   ├── vr_recovery_screen.dart
│   └── final_education_screen.dart
├── widgets/
│   └── vr_video_player.dart         # VR split-screen player
└── utils/
    ├── constants.dart                # Colors, styles, video paths
    └── sound_manager.dart            # Button sound effects

assets/
├── videos/                           # VR video files (6 videos)
└── sounds/                           # Button press sound
```

### Dependencies

- **provider**: ^6.1.1 - State management
- **video_player**: ^2.8.2 - Video playback
- **audioplayers**: ^5.2.1 - Sound effects

## 🎨 Design

**VR-Friendly Dark Theme:**
- Dark background (#0A0E27) for VR comfort
- High contrast colors
- Large buttons (300x80)
- Clear typography

**Colors:**
- Primary: #6C63FF (purple)
- Secondary: #4ECDC4 (teal)
- Success: #45B7D1 (blue)
- Warning: #FFA07A (orange)
- Danger: #FF6B6B (red)

## 🎞️ VR Implementation

### Split-Screen Layout

The `VRVideoPlayer` widget displays the same video twice side-by-side for VR Box viewing:

```
┌─────────────────────┬─────────────────────┐
│                     │                     │
│   Left Eye View     │   Right Eye View    │
│   (same video)      │   (same video)      │
│                     │                     │
└─────────────────────┴─────────────────────┘
```

### VR Mode Features

- ✅ Fullscreen immersive mode (hides system UI)
- ✅ Auto-play on load
- ✅ Auto-exit on video completion
- ✅ No user controls (no play/pause/seek)
- ✅ Landscape orientation locked
- ✅ Screen stays on during playback

## 🧪 Testing

### Run Tests

```bash
fvm flutter test
```

### Manual Testing Checklist

1. **Navigation Flow**
   - [ ] Main menu displays correctly
   - [ ] Role selection works (Gay/PSK)
   - [ ] Behavior selection works (Risky/Safe)
   - [ ] All 4 role+behavior combinations work

2. **VR Mode**
   - [ ] Video loads and auto-plays
   - [ ] Split-screen displays correctly
   - [ ] Video completes and auto-exits
   - [ ] System UI is hidden during playback

3. **Health Logic**
   - [ ] Risky behavior → HIV Positive
   - [ ] Safe behavior → Healthy
   - [ ] HIV+ leads to decision screen
   - [ ] Healthy leads to final education

4. **Decision Outcomes**
   - [ ] YES → Negative outcome video → Main menu
   - [ ] NO → Recovery video → Final education

5. **VR Box Testing**
   - [ ] Test on physical device with VR Box
   - [ ] Verify video alignment
   - [ ] Check comfort and viewing experience

## 🔧 Troubleshooting

### Video Doesn't Play

**Issue**: Video shows loading screen forever or error.

**Solutions**:
1. Verify video files are in `assets/videos/` directory
2. Ensure video files are named exactly as specified
3. Check video format is MP4
4. Try different video codecs (H.264 recommended)
5. Reduce video resolution if file is too large

### Sound Doesn't Work

**Issue**: Button press sounds not playing.

**Solutions**:
1. Sound failures are handled gracefully - app still works
2. Add `button_press.mp3` to `assets/sounds/`
3. Check audio file format (MP3 or WAV recommended)
4. Verify device volume is not muted

### Orientation Issues

**Issue**: App doesn't lock to landscape.

**Solutions**:
1. Check `AndroidManifest.xml` has `android:screenOrientation="landscape"`
2. Verify `main.dart` sets preferred orientations
3. Test on different Android devices

### Build Errors

**Issue**: Flutter build fails.

**Solutions**:
```bash
# Clean build
fvm flutter clean
fvm flutter pub get

# Update dependencies
fvm flutter pub upgrade

# Check Flutter doctor
fvm flutter doctor -v
```

## 📝 Notes

### Constraints (By Design)

- ❌ No VR controllers
- ❌ No gaze interaction
- ❌ No in-VR user interaction
- ❌ No networking or API calls
- ❌ No backend or analytics
- ❌ No authentication
- ❌ No Unity or game engine

### Production Checklist

Before releasing:

- [ ] All 6 video files are optimized and tested
- [ ] Videos are in VR-compatible format
- [ ] APK is signed for distribution
- [ ] App has been tested on multiple devices
- [ ] VR Box compatibility verified
- [ ] User flow tested end-to-end
- [ ] Educational content reviewed for accuracy

## 📄 License

Project developed for HIV/AIDS prevention education.

## 🤝 Support

For issues or questions, refer to the [ARCHITECTURE.md](ARCHITECTURE.md) document for detailed technical information.
