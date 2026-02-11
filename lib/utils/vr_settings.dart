import 'package:shared_preferences/shared_preferences.dart';

/// Singleton to manage VR Lens Distortion settings
class VRSettings {
  static final VRSettings _instance = VRSettings._internal();
  factory VRSettings() => _instance;
  VRSettings._internal();

  // Default values optimized for standard VR Box (45mm object distance)
  double _k1 = 0.02;
  double _k2 = 0.01;
  double _ipdOffset = 0.0;
  double _pixelRatio = 3.0;

  // Getters
  double get k1 => _k1;
  double get k2 => _k2;
  double get ipdOffset => _ipdOffset;
  double get pixelRatio => _pixelRatio;

  // Load settings from SharedPreferences
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _k1 = prefs.getDouble('vr_k1') ?? 0.02;
    _k2 = prefs.getDouble('vr_k2') ?? 0.01;
    _ipdOffset = prefs.getDouble('vr_ipd_offset') ?? 0.0;
    _pixelRatio = prefs.getDouble('vr_pixel_ratio') ?? 3.0;
  }

  // Save settings to SharedPreferences
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('vr_k1', _k1);
    await prefs.setDouble('vr_k2', _k2);
    await prefs.setDouble('vr_ipd_offset', _ipdOffset);
    await prefs.setDouble('vr_pixel_ratio', _pixelRatio);
  }

  // Update values (call save() after to persist)
  void updateK1(double value) => _k1 = value;
  void updateK2(double value) => _k2 = value;
  void updateIpdOffset(double value) => _ipdOffset = value;
  void updatePixelRatio(double value) => _pixelRatio = value;

  // Reset to defaults
  void reset() {
    _k1 = 0.02;
    _k2 = 0.01;
    _ipdOffset = 0.0;
    _pixelRatio = 3.0;
  }
}
