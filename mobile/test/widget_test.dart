import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/main.dart';

void main() {
  testWidgets('Splitly app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SplitlyApp());

    expect(find.text('Splitly'), findsOneWidget);
  });
}