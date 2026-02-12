import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart'; // Needed for RenderRepaintBoundary

class VRLensDistortion extends StatefulWidget {
  final Widget child;
  final double k1;
  final double k2;
  final double ipdOffset; // 0.0 to 0.1 usually
  final double colorClamp; // 0.0 to 1.0 (e.g. 0.9)

  const VRLensDistortion({
    Key? key,
    required this.child,
    this.k1 = 0.20,
    this.k2 = 0.15,
    this.ipdOffset = 0.04,
    this.colorClamp = 0.9,
  }) : super(key: key);

  @override
  State<VRLensDistortion> createState() => _VRLensDistortionState();
}

class _VRLensDistortionState extends State<VRLensDistortion>
    with SingleTickerProviderStateMixin {
  ui.FragmentProgram? _program;
  final GlobalKey _repaintKey = GlobalKey();
  ui.Image? _capturedImage;
  bool _readyToCapture = false;
  late Ticker _ticker;
  Completer<void>? _captureCompleter;

  @override
  void initState() {
    super.initState();
    _loadShader();
    _ticker = createTicker(_onTick);
  }

  Future<void> _loadShader() async {
    try {
      final program =
          await ui.FragmentProgram.fromAsset('shaders/vr_distortion.frag');
      if (mounted) {
        setState(() {
          _program = program;
        });
        _ticker.start();
      }
    } catch (e) {
      debugPrint('Failed to load VR shader: $e');
    }
  }

  void _onTick(Duration elapsed) {
    if (_readyToCapture && _captureCompleter == null) {
      _captureFrame();
    }
  }

  Future<void> _captureFrame() async {
    _captureCompleter = Completer<void>();

    try {
      final context = _repaintKey.currentContext;
      if (context == null) return;

      final boundary = context.findRenderObject();

      if (boundary is! RenderRepaintBoundary) {
        return;
      }

      // Capture logic
      // pixelRatio 3.0 provides maximum sharpness for VR text
      final image = await boundary.toImage(pixelRatio: 3.0);

      if (mounted) {
        setState(() {
          _capturedImage?.dispose();
          _capturedImage = image;
        });
      } else {
        image.dispose();
      }
    } catch (e) {
      debugPrint('Error capturing VR frame: $e');
    } finally {
      if (mounted) {
        _captureCompleter?.complete();
        _captureCompleter = null;
      }
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _capturedImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_program == null) {
      return widget.child;
    }

    return Stack(
      children: [
        // Distorted background (visual only)
        if (_capturedImage != null)
          Positioned.fill(
            child: CustomPaint(
              painter: VRDistortionPainter(
                image: _capturedImage!,
                program: _program!,
                k1: widget.k1,
                k2: widget.k2,
                ipdOffset: widget.ipdOffset,
                colorClamp: widget.colorClamp,
              ),
            ),
          ),

        // Hidden source for RepaintBoundary capture
        Opacity(
          opacity: 0.0,
          child: RepaintBoundary(
            key: _repaintKey,
            child: Builder(builder: (context) {
              if (!_readyToCapture) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _readyToCapture = true;
                });
              }
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: widget.child,
              );
            }),
          ),
        ),

        // Interactive overlay (actual widget for touch events)
        Positioned.fill(
          child: IgnorePointer(
            ignoring: false,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class VRDistortionPainter extends CustomPainter {
  final ui.Image image;
  final ui.FragmentProgram program;
  final double k1;
  final double k2;
  final double ipdOffset;
  final double colorClamp;

  VRDistortionPainter({
    required this.image,
    required this.program,
    required this.k1,
    required this.k2,
    required this.ipdOffset,
    required this.colorClamp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();

    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    shader.setImageSampler(0, image);
    shader.setFloat(2, k1);
    shader.setFloat(3, k2);
    shader.setFloat(4, ipdOffset);
    shader.setFloat(5, colorClamp);

    final paint = Paint()..shader = shader;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant VRDistortionPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.k1 != k1 ||
        oldDelegate.k2 != k2 ||
        oldDelegate.ipdOffset != ipdOffset ||
        oldDelegate.colorClamp != colorClamp;
  }
}
