import 'package:anka_super_loading_package/anka_super_loading_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnkaSuperLoading smoke', () {
    for (final style in LoadingStyle.values) {
      testWidgets('pumps $style without error', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AnkaSuperLoading(style: style),
              ),
            ),
          ),
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(AnkaSuperLoading), findsOneWidget);
      });

      testWidgets('semantics label for $style', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AnkaSuperLoading(
                  style: style,
                  semanticsLabel: 'Please wait',
                ),
              ),
            ),
          ),
        );
        expect(
          find.bySemanticsLabel('Please wait'),
          findsOneWidget,
        );
      });
    }
  });
}
