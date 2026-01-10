# VR Box Application - Architecture Document

Detailed technical architecture for the HIV/AIDS prevention VR education app.

## Table of Contents

1. [State Machine Design](#state-machine-design)
2. [Navigation Flow](#navigation-flow)
3. [Video Selection Logic](#video-selection-logic)
4. [VR Implementation](#vr-implementation)
5. [Code Organization](#code-organization)
6. [Design Patterns](#design-patterns)

---

## State Machine Design

### AppState Enum

The application uses a simple enum-based state machine with 9 states:

```dart
enum AppState {
  mainMenu,           // State 0
  roleSelection,      // State 1
  behaviorSelection,  // State 2
  vrTimeLapse,        // State 3
  healthResult,       // State 4
  decision,           // State 5
  vrNegativeOutcome,  // State 6A
  vrRecovery,         // State 6B
  finalEducation,     // State 7
}
```

### State Transition Diagram

```
          ┌──────────────┐
          │  Main Menu   │ ◄──┐
          │   (State 0)  │    │
          └──────┬───────┘    │
                 │ play       │
                 ▼            │
          ┌──────────────┐    │
          │ Role Select  │    │
          │   (State 1)  │    │
          └──────┬───────┘    │
                 │ gay/psk    │
                 ▼            │
          ┌──────────────┐    │
          │  Behavior    │    │
          │   (State 2)  │    │
          └──────┬───────┘    │
                 │ risky/safe │
                 ▼            │
          ┌──────────────┐    │
          │  VR: Time    │    │
          │    Lapse     │    │
          │   (State 3)  │    │
          └──────┬───────┘    │
                 │ auto       │
                 ▼            │
          ┌──────────────┐    │
          │   Health     │    │
          │   Result     │    │
          │   (State 4)  │    │
          └──────┬───────┘    │
                 │            │
        ┌────────┴────────┐   │
        │                 │   │
     HIV+ ?           Healthy │
        │                 │   │
        ▼                 │   │
  ┌──────────┐            │   │
  │ Decision │            │   │
  │(State 5) │            │   │
  └────┬─────┘            │   │
       │                  │   │
  ┌────┴─────┐            │   │
  │          │            │   │
 YES        NO            │   │
  │          │            │   │
  ▼          ▼            ▼   │
┌───────┐ ┌────────┐  ┌──────────┐
│ VR:   │ │ VR:    │  │  Final   │
│ Death │ │Recovery│  │Education │
│(6A)   │ │ (6B)   │  │ (State 7)│
└───┬───┘ └───┬────┘  └────┬─────┘
    │         │            │
    │         └────────────┘
    │         restart      │
    └──────────────────────┘
```

### State Transition Rules

| From State | Action | To State | Conditions |
|------------|--------|----------|------------|
| mainMenu | Play button | roleSelection | None |
| roleSelection | Select role | behaviorSelection | Role selected (gay/psk) |
| behaviorSelection | Select behavior | vrTimeLapse | Behavior selected (risky/safe) |
| vrTimeLapse | Video complete | healthResult | Auto-triggered |
| healthResult | Continue (HIV+) | decision | isHealthy == false |
| healthResult | Continue (Healthy) | finalEducation | isHealthy == true |
| decision | YES | vrNegativeOutcome | Continue risky = true |
| decision | NO | vrRecovery | Continue risky = false |
| vrNegativeOutcome | Video complete | mainMenu | Auto-triggered |
| vrRecovery | Video complete | finalEducation | Auto-triggered |
| finalEducation | Restart | mainMenu | Resets all state |

---

## Navigation Flow

### Navigator Implementation

The app uses a single `Consumer` widget that rebuilds based on `AppState` changes:

```dart
Consumer<AppController>(
  builder: (context, controller, _) {
    switch (controller.currentState) {
      case AppState.mainMenu:
        return const MainMenuScreen();
      // ... other cases
    }
  },
)
```

**Benefits:**
- Simple and declarative
- No route management complexity
- Predictable state transitions
- Easy to debug

### Screen Lifecycle

1. **Normal Mode Screens** (Main Menu, Role Selection, etc.)
   - User interacts with buttons
   - Button press triggers `AppController` method
   - Controller updates state and notifies listeners
   - Navigator rebuilds with new screen

2. **VR Mode Screens** (Time Lapse, Negative Outcome, Recovery)
   - Screen loads `VRVideoPlayer` widget
   - Video auto-plays on initialization
   - Video player listens for completion
   - On completion, calls controller method
   - Controller updates state → exits VR mode

---

## Video Selection Logic

### Video Mapping

Videos are mapped using a simple key-value structure:

```dart
Map<String, String> videos = {
  'gay_risky': 'assets/videos/gay_risky.mp4',
  'gay_safe': 'assets/videos/gay_safe.mp4',
  'psk_risky': 'assets/videos/psk_risky.mp4',
  'psk_safe': 'assets/videos/psk_safe.mp4',
  'positive_end': 'assets/videos/positive_end.mp4',
  'recovery': 'assets/videos/recovery.mp4',
};
```

### Selection Algorithm

**For Time Lapse (State 3):**

```
videoPath = role + "_" + behavior
Examples:
  gay + risky → "gay_risky" → gay_risky.mp4
  psk + safe → "psk_safe" → psk_safe.mp4
```

**For Outcome Videos (State 6A/6B):**

```
continueRisky = true → "positive_end" → positive_end.mp4
continueRisky = false → "recovery" → recovery.mp4
```

**Implementation:**

```dart
// Time lapse video
String getTimeLapseVideoPath() {
  final role = selectedRole == UserRole.gay ? 'gay' : 'psk';
  final behavior = selectedBehavior == BehaviorType.risky ? 'risky' : 'safe';
  return VideoAssets.getVideoPath(role, behavior);
}

// Outcome video
String getOutcomeVideoPath() {
  return VideoAssets.getOutcomeVideo(continueRiskyBehavior!);
}
```

### Health Determination Logic

Simple boolean logic based on behavior:

```dart
isHealthy = (selectedBehavior == BehaviorType.safe);

// Risky → false → HIV Positive
// Safe → true → Healthy
```

---

## VR Implementation

### VRVideoPlayer Widget Architecture

```
VRVideoPlayer (StatefulWidget)
├── VideoPlayerController (video_player package)
├── Video Listener (completion detection)
└── Split-Screen Layout (Row with 2 VideoPlayer widgets)
```

### Video Player Lifecycle

```
1. initState()
   ├── Enter fullscreen mode
   ├── Initialize VideoPlayerController
   ├── Load video from assets
   ├── Add completion listener
   └── Auto-play video

2. Video Playing
   ├── Split-screen rendering (left/right)
   └── Listen for completion

3. Video Complete
   ├── Remove listener
   ├── Call onVideoComplete callback
   └── Controller updates state (exits VR)

4. dispose()
   ├── Remove listener
   ├── Dispose controller
   └── Exit fullscreen mode
```

### Split-Screen Implementation

```dart
Row(
  children: [
    // Left eye
    Expanded(
      child: VideoPlayer(_controller),
    ),
    // Right eye (same video)
    Expanded(
      child: VideoPlayer(_controller),
    ),
  ],
)
```

**Note**: Both eyes show the same video. For true stereoscopic 3D, you would need:
- Videos recorded with VR camera
- Side-by-side or top-bottom 3D format
- Different rendering for each eye

### Fullscreen Mode

```dart
// Enter VR mode
SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

// Exit VR mode
SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
```

### Error Handling

The VR player handles errors gracefully:

```dart
if (videoInitializationFails) {
  // Show error screen with "Continue" button
  // User can proceed instead of being stuck
}
```

---

## Code Organization

### Layer Architecture

```
┌─────────────────────────────────────┐
│         Presentation Layer           │
│  (Screens - UI only, no logic)      │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│       Application Layer              │
│  (AppController - state & logic)    │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           Widget Layer               │
│  (VRVideoPlayer - reusable)         │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│          Utils/Constants             │
│  (Config, assets, helpers)          │
└─────────────────────────────────────┘
```

### Dependency Flow

```
Screens → AppController → Enums
   ↓
Widgets → Constants
   ↓
SoundManager
```

**Rules:**
- Screens only trigger controller methods (no business logic)
- Controller manages all state and logic
- Widgets are reusable and self-contained
- Utils/constants are pure functions

---

## Design Patterns

### 1. State Pattern

**Implementation**: `AppState` enum + `AppController`

**Benefits**:
- Eliminates complex routing
- Clear state representation
- Easy to debug
- Predictable flow

### 2. Observer Pattern

**Implementation**: `ChangeNotifier` + `Provider` + `Consumer`

**Flow**:
```
User Action → Controller Method → notifyListeners() → Consumer Rebuilds
```

### 3. Strategy Pattern

**Implementation**: Video selection based on user choices

**Example**:
```dart
// Strategy changes based on role + behavior
getTimeLapseVideoPath() // Different video for each combination
```

### 4. Template Method Pattern

**Implementation**: `VRVideoPlayer` widget

**Template**:
```
1. Initialize video
2. Auto-play
3. Listen for completion
4. Trigger callback
5. Cleanup
```

### 5. Singleton Pattern

**Implementation**: `SoundManager`

**Rationale**: Single audio player instance across app

```dart
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
}
```

---

## Performance Considerations

### Video Loading

- Videos loaded from assets (faster than network)
- Video initialization happens asynchronously
- Loading screen shown during initialization
- No preloading (videos loaded on-demand)

### Memory Management

- Video controller disposed when screen unmounts
- Single video plays at a time
- No video caching (to keep memory low)

### State Updates

- `notifyListeners()` only called when state changes
- Minimal widget rebuilds (only `Consumer` rebuilds)
- No unnecessary re-renders

---

## Testing Strategy

### Unit Tests

Test `AppController` logic:
- State transitions
- Video path resolution
- Health determination
- Decision logic

### Widget Tests

Test screen rendering:
- Correct buttons displayed
- Text content accurate
- State-based rendering

### Integration Tests

Test complete flows:
- Gay + Risky → HIV+ → YES → Death
- PSK + Safe → Healthy → Education
- All 4 role+behavior combinations

### Manual VR Testing

- Physical device required
- VR Box compatibility
- Video alignment
- User experience

---

## Security & Privacy

### Offline-Only Design

- No network requests
- No data collection
- No analytics
- No user tracking
- No authentication

### Data Storage

- No user data stored
- No session persistence
- State resets on app close

---

## Future Enhancements

**Not in current scope, but possible**:

1. **True Stereoscopic 3D**
   - Side-by-side 3D video format
   - Separate rendering for each eye

2. **Progress Tracking**
   - Local storage of user progress
   - Completion statistics

3. **Multiple Languages**
   - Internationalization (i18n)
   - Localized video content

4. **Advanced VR Features**
   - Head tracking (with gyroscope)
   - Gaze-based interaction
   - 360° video support

---

## Conclusion

This architecture prioritizes:
- ✅ Simplicity over complexity
- ✅ Predictability over flexibility
- ✅ Offline reliability
- ✅ Easy maintenance
- ✅ Clear state flow

The design intentionally avoids:
- ❌ Over-engineering
- ❌ Complex routing
- ❌ Unnecessary abstractions
- ❌ External dependencies
- ❌ Network complexity

**Result**: A production-ready, maintainable VR education app with clear, predictable behavior.
