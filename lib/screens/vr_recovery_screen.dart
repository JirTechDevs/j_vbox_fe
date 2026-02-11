import "dart:async";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../widgets/vr_video_player.dart';

/// State 6B - VR Recovery Screen
/// VR mode: Flashback + education showing recovery path
/// Shown if user chose to stop risky behavior
/// No user interaction - auto-exits when video ends
class VRRecoveryScreen extends StatelessWidget {
  const VRRecoveryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final videoPath = controller.getOutcomeVideoPath();

    return Scaffold(
      backgroundColor: Colors.black,
      body: VRVideoPlayer(
        videoPath: videoPath,
        onVideoComplete: () async {
          // Wait 5 seconds on result screen
          await Future.delayed(const Duration(seconds: 5));
          // Auto-exit VR and restart scenario
          if (context.mounted) {
            controller.completeRecovery();
          }
        },
      ),
    );
  }
}
