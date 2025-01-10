import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_quest/common.dart';

class AppCrudTests {
  static Future<void> createHabit(WidgetTester tester, String habitName) async {
    expect(find.text('HABIT QUEST'), findsOne);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Tap to change emoji'), findsOne);
    await tester.pumpAndSettle();
    final randomInt = Random().nextInt(50);
    final habitName = 'Random habit $randomInt';
    await tester.enterText(
      find.byType(TextField).first,
      habitName,
    );
    await tester.pumpAndSettle();
    final createButton = find.text('Done');
    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();
  }

  static Future<void> editHabit(WidgetTester tester, String habitName) async {
    final editIcon = find.byIcon(CustomIcons.arrow_miss).last;
    await tester.ensureVisible(editIcon);
    await tester.pumpAndSettle();
    await tester.tap(editIcon);
    await tester.pumpAndSettle();
    final editButton = find.text('Edit').first;
    await tester.tap(editButton);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Tap to change emoji'), findsOne);
    await tester.pumpAndSettle();
    final randomInt = Random().nextInt(50);
    final habitName = 'Random habit $randomInt';
    await tester.enterText(
      find.byType(TextField).first,
      habitName,
    );
    await tester.pumpAndSettle();
    final createButton = find.text('Update');
    await tester.ensureVisible(createButton);
    await tester.pumpAndSettle();
    await tester.tap(createButton);
    await tester.pumpAndSettle();
  }
}
