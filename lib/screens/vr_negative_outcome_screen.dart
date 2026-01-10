import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../widgets/vr_video_player.dart';

/// State 6A - VR Negative Outcome Screen
/// VR mode: Health deterioration leading to death
/// Shown if user chose to continue risky behavior
/// No user interaction - auto-exits when video ends
class VRNegativeOutcomeScreen extends StatelessWidget {
  const VRNegativeOutcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final videoPath = controller.getOutcomeVideoPath();

    return Scaffold(
      backgroundColor: Colors.black,
      body: VRVideoPlayer(
        videoPath: videoPath,
        onVideoComplete: () {
          // Auto-exit VR and return to main menu (app ends)
          controller.completeNegativeOutcome();
        },
      ),
    );
  }
}
