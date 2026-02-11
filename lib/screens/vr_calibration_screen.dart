import 'package:flutter/material.dart';
import '../widgets/vr_splitter.dart';
import '../widgets/vr_lens_distortion.dart';
import '../utils/constants.dart';
import '../utils/vr_settings.dart';

/// VR Calibration Screen
/// Allows real-time adjustment of K1, K2, IPD Offset while wearing headset
class VRCalibrationScreen extends StatefulWidget {
  const VRCalibrationScreen({Key? key}) : super(key: key);

  @override
  State<VRCalibrationScreen> createState() => _VRCalibrationScreenState();
}

class _VRCalibrationScreenState extends State<VRCalibrationScreen> {
  final VRSettings _settings = VRSettings();
  late double _k1;
  late double _k2;
  late double _ipdOffset;

  @override
  void initState() {
    super.initState();
    _k1 = _settings.k1;
    _k2 = _settings.k2;
    _ipdOffset = _settings.ipdOffset;
  }

  void _updateAndRebuild() {
    setState(() {
      _settings.updateK1(_k1);
      _settings.updateK2(_k2);
      _settings.updateIpdOffset(_ipdOffset);
    });
  }

  Future<void> _saveAndExit() async {
    await _settings.save();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: VRLensDistortion(
        k1: _k1,
        k2: _k2,
        ipdOffset: _ipdOffset,
        child: VRSplitter(
          builder: (context, eyeIndex) {
            return Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.cosmicBackground,
              ),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Title
                          Text(
                            'VR Calibration',
                            style: AppTextStyles.title.copyWith(fontSize: 20),
                          ),
                          const SizedBox(height: 8),

                          // Test Pattern
                          _buildTestPattern(),
                          const SizedBox(height: 16),

                          // K1 Slider
                          _buildSlider(
                            label: 'K1 (Barrel)',
                            value: _k1,
                            min: 0.0,
                            max: 0.5,
                            onChanged: (v) {
                              _k1 = v;
                              _updateAndRebuild();
                            },
                          ),

                          // K2 Slider
                          _buildSlider(
                            label: 'K2 (Pincushion)',
                            value: _k2,
                            min: 0.0,
                            max: 0.3,
                            onChanged: (v) {
                              _k2 = v;
                              _updateAndRebuild();
                            },
                          ),

                          // IPD Offset Slider
                          _buildSlider(
                            label: 'IPD Offset',
                            value: _ipdOffset,
                            min: -0.1,
                            max: 0.1,
                            onChanged: (v) {
                              _ipdOffset = v;
                              _updateAndRebuild();
                            },
                          ),

                          const SizedBox(height: 16),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _settings.reset();
                                    _k1 = _settings.k1;
                                    _k2 = _settings.k2;
                                    _ipdOffset = _settings.ipdOffset;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                ),
                                child: const Text('Reset'),
                              ),
                              ElevatedButton(
                                onPressed: _saveAndExit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.success,
                                ),
                                child: const Text('Save & Exit'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTestPattern() {
    return Container(
      width: 250,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        children: [
          // Horizontal grid lines
          ...List.generate(5, (i) {
            return Positioned(
              left: 0,
              right: 0,
              top: (i * 150 / 4).toDouble(),
              child: Container(height: 1, color: Colors.white30),
            );
          }),
          // Vertical grid lines
          ...List.generate(7, (i) {
            return Positioned(
              top: 0,
              bottom: 0,
              left: (i * 250 / 6).toDouble(),
              child: Container(width: 1, color: Colors.white30),
            );
          }),
          // Center crosshair
          Center(
            child: Icon(Icons.add, color: AppColors.primary, size: 32),
          ),
          // Test text
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Text(
              'CALIBRATE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Text(
              'Lines should be straight',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Text(
          '$label: ${value.toStringAsFixed(3)}',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () {
                final newVal = (value - 0.01).clamp(min, max);
                onChanged(newVal);
              },
            ),
            Expanded(
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: 100,
                activeColor: AppColors.primary,
                onChanged: onChanged,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                final newVal = (value + 0.01).clamp(min, max);
                onChanged(newVal);
              },
            ),
          ],
        ),
      ],
    );
  }
}
