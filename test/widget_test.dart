import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('RideOn app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RideOnApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.byType(RideOnApp), findsOneWidget);
  });
}
