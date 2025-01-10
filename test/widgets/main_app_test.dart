import 'package:flutter_test/flutter_test.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/main.dart';

void main() {
  testWidgets('HabitQuest widget builds successfully',
      (WidgetTester tester) async {
    await AppDependencies.initialize();
    // Build the widget
    await tester.pumpWidget(
      const ProviderScope(
        child: HabitQuest(),
      ),
    );

    // Verify MaterialApp.router exists in the widget tree
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verify the debug banner is not shown
    final materialAppWidget =
        tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialAppWidget.debugShowCheckedModeBanner, isFalse);

    // Verify the title is set correctly
    expect(materialAppWidget.title, 'Habit Quest');
  });
}
