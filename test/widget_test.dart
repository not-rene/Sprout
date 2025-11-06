import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sprout/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SproutApp());

    expect(find.text('Welcome to Sprout!'), findsOneWidget);
    expect(find.text('Sprout 🌱'), findsOneWidget);
  });
}
