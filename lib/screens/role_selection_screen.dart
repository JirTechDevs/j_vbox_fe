import '../widgets/vr_splitter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import '../controllers/app_controller.dart';
import '../models/app_enums.dart';
import '../utils/constants.dart';
import '../utils/sound_manager.dart';

/// State 1 - Role Selection Screen
/// Uses gyroscope to detect head tilt for selection
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  StreamSubscription? _gyroSubscription;
  UserRole? _highlightedRole;
  double _confirmProgress = 0.0;
  Timer? _confirmTimer;
  static const double _tiltThreshold = 2.0; // m/s² threshold for accelerometer
  static const Duration _confirmDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _startGyroscope();
    // Play instruction voiceover
    SoundManager().playSound(SoundAssets.choiceVO);
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    _confirmTimer?.cancel();
    super.dispose();
  }

  void _startGyroscope() {
    // Use accelerometer for static tilt detection in landscape mode
    _gyroSubscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      // In landscape mode: X-axis = left/right tilt
      // Positive X = tilted RIGHT, Negative X = tilted LEFT
      final tiltX = event.x;

      UserRole? newHighlight;
      if (tiltX < -_tiltThreshold) {
        newHighlight = UserRole.gay; // Tilt LEFT = Laki-laki
      } else if (tiltX > _tiltThreshold) {
        newHighlight = UserRole.psk; // Tilt RIGHT = Perempuan
      }

      if (newHighlight != _highlightedRole) {
        setState(() {
          _highlightedRole = newHighlight;
          _confirmProgress = 0.0;
        });
        _confirmTimer?.cancel();

        if (newHighlight != null) {
          // Start confirmation timer
          _confirmTimer = Timer.periodic(
            const Duration(milliseconds: 50),
            (timer) {
              setState(() {
                _confirmProgress += 50 / _confirmDuration.inMilliseconds;
                if (_confirmProgress >= 1.0) {
                  _confirmSelection(_highlightedRole!);
                  timer.cancel();
                }
              });
            },
          );
        }
      }
    });
  }

  void _confirmSelection(UserRole role) {
    _gyroSubscription?.cancel();
    _confirmTimer?.cancel();
    // SoundManager().playSound handles stopping previous sound
    SoundManager().playButtonPress();
    context.read<AppController>().selectRole(role);
  }

  void _manualSelect(UserRole role) {
    _confirmSelection(role);
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        controller.goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: VRSplitter(
          builder: (context, eyeIndex) {
            final isLeftEye = eyeIndex == 0;

            return Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.cosmicBackground,
              ),
              child: SafeArea(
                child: Center(
                  child: Transform.scale(
                    scale: 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        const Text(
                          'Pilihan Perspektif',
                          style: AppTextStyles.title,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Show ONLY the icon for this eye with highlight effect
                        GestureDetector(
                          onTap: () => _manualSelect(
                            isLeftEye ? UserRole.gay : UserRole.psk,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glow effect when highlighted
                              if (_highlightedRole ==
                                  (isLeftEye ? UserRole.gay : UserRole.psk))
                                Container(
                                  width: 300,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.primary.withOpacity(0.8),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),

                              // Image
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _highlightedRole ==
                                            (isLeftEye
                                                ? UserRole.gay
                                                : UserRole.psk)
                                        ? AppColors.primary
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(17),
                                  child: Image.asset(
                                    isLeftEye
                                        ? 'assets/images/ic-role-1.png'
                                        : 'assets/images/ic-role-2.png',
                                    width: 280,
                                    height: 220,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),

                              // Confirmation progress circle
                              if (_highlightedRole ==
                                  (isLeftEye ? UserRole.gay : UserRole.psk))
                                Positioned(
                                  bottom: 10,
                                  child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: CircularProgressIndicator(
                                      value: _confirmProgress,
                                      strokeWidth: 4,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
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
}
