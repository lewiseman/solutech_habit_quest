import 'package:habit_quest/common.dart';

class HabitsCalcData {
  HabitsCalcData({required this.habits}) {
    habits.sort((a, b) => a.time.compareTo(b.time));
  }
  final List<Habit> habits;
}
