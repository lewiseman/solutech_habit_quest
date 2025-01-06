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
    required this.paused,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    this.description,
    this.days,
  });

  factory Habit.fromJson(Map<String, dynamic> data) {
    return Habit(
      id: data[r'$id'] as String,
      title: data['title'] as String,
      emoji: data['emoji'] as String,
      description: data['description'] as String?,
      time: data['time'] as String,
      days: data['days'] != null ? List<String>.from(data['days'] as List) : [],
      startDate: DateTime.parse(data['start_date'] as String),
      frequency: HabitFrequency.values.firstWhere(
        (e) => e.displayName == data['frequency'],
      ),
      paused: data['paused'] as bool,
      userId: data['user_id'] as String,
      createdAt: DateTime.parse(data[r'$createdAt'] as String),
      updatedAt: DateTime.parse(data[r'$updatedAt'] as String),
    );
  }

  factory Habit.justId(String id) {
    return Habit(
      id: id,
      title: '',
      emoji: '',
      time: '00:00',
      startDate: DateTime.now(),
      frequency: HabitFrequency.daily,
      paused: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: '',
    );
  }

  final String id;
  final String title;
  final String emoji;
  final String? description;
  final String time;
  final DateTime startDate;
  final List<String>? days;
  final HabitFrequency frequency;
  final bool paused;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'emoji': emoji,
      'description': description,
      'time': time,
      'start_date': startDate.toIso8601String(),
      'days': days,
      'frequency': frequency.displayName,
      'paused': paused,
      'user_id': userId,
    };
  }

  bool relevant(DateTime date) {
    final startDayReached = date.year >= startDate.year &&
        date.month >= startDate.month &&
        date.day >= startDate.day;

    return startDayReached;
  }

  TimeOfDay timeValue() {
    return TimeOfDay(
      hour: int.parse(time.split(':')[0]),
      minute: int.parse(time.split(':')[1]),
    );
  }

  Habit copyWith({
    String? title,
    String? emoji,
    String? description,
    String? time,
    DateTime? startDate,
    List<String>? days,
    HabitFrequency? frequency,
    bool? paused,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id,
      title: title ?? this.title,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
      time: time ?? this.time,
      startDate: startDate ?? this.startDate,
      days: days ?? this.days,
      frequency: frequency ?? this.frequency,
      paused: paused ?? this.paused,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
