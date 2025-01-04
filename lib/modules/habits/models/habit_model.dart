import 'package:habit_quest/common.dart';

enum HabitFrequency {
  daily,
  weekly,
  once;

  String get displayName {
    switch (this) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.once:
        return 'Once';
    }
  }
}

class Habit {
  Habit({
    required this.id,
    required this.title,
    required this.emoji,
    required this.time,
    required this.startDate,
    required this.frequency,
    this.description,
    this.days = '',
  });
  final String id;
  final String title;
  final String emoji;
  final String? description;
  final TimeOfDay time;
  final DateTime startDate;
  final String days;
  final HabitFrequency frequency;
}
