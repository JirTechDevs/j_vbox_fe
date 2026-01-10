import 'package:audioplayers/audioplayers.dart';
import 'constants.dart';

/// Simple sound manager for button press effects
class SoundManager {
  static final SoundManager _instance = SoundManager._internal();
  factory SoundManager() => _instance;
  SoundManager._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _initialized = false;

  /// Initialize sound manager
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Set audio mode for sound effects
      await _audioPlayer.setReleaseMode(ReleaseMode.stop);
      _initialized = true;
    } catch (e) {
      // Silently fail if audio initialization fails
      print('Sound initialization failed: $e');
    }
  }

  /// Play button press sound
  Future<void> playButtonPress() async {
    if (!_initialized) return;

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(SoundAssets.buttonPress));
    } catch (e) {
      // Silently fail if sound playback fails
      print('Sound playback failed: $e');
    }
  }

  /// Dispose audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
