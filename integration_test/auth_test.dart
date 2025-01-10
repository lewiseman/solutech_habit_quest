import 'package:flutter_test/flutter_test.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/main.dart';

class AuthTests {
  static Future<void> loginTest(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HabitQuest()));
    await tester.pumpAndSettle();
    expect(find.text('HABIT QUEST'), findsOne);
    await tester.tap(find.text('I ALREADY HAVE AN ACCOUNT'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsAny);
    await tester.enterText(
      find.byType(HabitTextInput).first,
      'test@gmail.com',
    );
    await tester.enterText(
      find.byType(HabitTextInput).last,
      '12345678',
    );

    await tester.tap(find.text('Sign in').last);
    await tester.pumpAndSettle();
  }
}
