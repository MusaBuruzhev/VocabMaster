import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_master/main.dart';

void main() {
  testWidgets('VocabMasterApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VocabMasterApp());

    // Verify that the app starts with the login view.
    expect(find.text('VocabMaster'), findsOneWidget);
  });
}