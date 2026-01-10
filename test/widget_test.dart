// Basic widget test for VR Box application

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:j_vbox_fe/main.dart';

void main() {
  testWidgets('App launches and shows main menu', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const VRBoxApp());

    // Verify that the main menu is displayed
    expect(find.text('VR Box Education'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);
  });
}
