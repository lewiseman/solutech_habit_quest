import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:habit_quest/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('description', () {
    testWidgets(
      'wowowowow',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();
      },
    );
  });

  // testWidgets("failing test example", (WidgetTester tester) async {
  //   expect(2 + 2, equals(4));
  // });
}
