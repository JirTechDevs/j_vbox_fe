import 'package:flutter/material.dart';

class VRSplitter extends StatelessWidget {
  final Widget Function(BuildContext context, int eyeIndex) builder;

  const VRSplitter({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 1.0),
            child: ClipRect(
              child: KeyedSubtree(
                key: const ValueKey('left_eye'),
                child: builder(context, 0),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 1.0),
            child: ClipRect(
              child: KeyedSubtree(
                key: const ValueKey('right_eye'),
                child: builder(context, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
