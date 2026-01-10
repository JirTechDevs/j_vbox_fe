import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/app_controller.dart';
import '../widgets/vr_video_player.dart';

/// State 3 - VR Time Lapse Screen
/// VR mode: 5 year time lapse based on role + behavior
/// No user interaction - auto-exits when video ends
class VRTimeLapseScreen extends StatelessWidget {
  const VRTimeLapseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AppController>();
    final videoPath = controller.getTimeLapseVideoPath();

    return Scaffold(
      backgroundColor: Colors.black,
      body: VRVideoPlayer(
        videoPath: videoPath,
        onVideoComplete: () {
          // Auto-exit VR and proceed to health result
          controller.completeTimeLapse();
        },
      ),
    );
  }
}
