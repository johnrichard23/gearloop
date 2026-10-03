import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/presentation/widgets/match_highlight_text.dart';

/// The (text, isBold) pieces the widget draws.
List<(String, bool)> _pieces(WidgetTester tester) {
  final rich = tester.widget<RichText>(find.byType(RichText).first);
  final pieces = <(String, bool)>[];
  rich.text.visitChildren((span) {
    if (span is TextSpan && span.text != null) {
      pieces.add((span.text!, span.style?.fontWeight == FontWeight.w700));
    }
    return true;
  });
  return pieces;
}

Future<void> _pump(WidgetTester tester, String text, String query) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: MatchHighlightText(text: text, query: query),
      ),
    ),
  );
}

void main() {
  testWidgets('bolds the matching letters and keeps the text casing', (
    tester,
  ) async {
    await _pump(tester, 'Strawberries', 'STR');
    expect(_pieces(tester), [('', false), ('Str', true), ('awberries', false)]);
  });

  testWidgets('bolds a match in the middle of the text', (tester) async {
    await _pump(tester, 'Sony A7 IV', 'a7');
    expect(_pieces(tester), [('Sony ', false), ('A7', true), (' IV', false)]);
  });

  testWidgets('shows plain text when nothing matches or the query is empty', (
    tester,
  ) async {
    await _pump(tester, 'Drone', 'xyz');
    expect(find.text('Drone'), findsOneWidget);
    await _pump(tester, 'Drone', '  ');
    expect(find.text('Drone'), findsOneWidget);
  });
}
