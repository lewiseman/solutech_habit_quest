import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_quest/common.dart';
import 'package:integration_test/integration_test.dart';

import 'auth_test.dart';
import 'crud_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.initialize();

  group('End to end test', () {
    testWidgets(
      'Simulate a user journey',
      (tester) async {
        await AuthTests.loginTest(tester);

        final randomInt = Random().nextInt(50);
        final habitName = 'Random habit $randomInt';

        await AppCrudTests.createHabit(tester, habitName);
        final randomInt2 = Random().nextInt(50);
        final habitName2 = 'Random habit $randomInt2';

        await AppCrudTests.editHabit(tester, habitName2);
        await tester.pump(const Duration(seconds: 15));
      },
    );

  });
}
