enum HabitActionType { done, skipped }

class HabitAction {
  const HabitAction({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.action,
    required this.updatedAt,
    required this.createdAt,
  });

  HabitAction.justId(this.id)
      : habitId = '',
        userId = '',
        action = HabitActionType.done,
        updatedAt = DateTime.now(),
        createdAt = DateTime.now();

  HabitAction.fromJson(Map<String, dynamic> data)
      : id = data[r'$id'] as String,
        habitId = data['habit_id'] as String,
        userId = data['user_id'] as String,
        action = data['action'] == 'done'
            ? HabitActionType.done
            : HabitActionType.skipped,
        updatedAt = DateTime.parse(data['my_updated_at'] as String),
        createdAt = DateTime.parse(data['my_created_at'] as String);

  final String id;
  final String habitId;
  final String userId;
  final HabitActionType action;
  final DateTime updatedAt;
  final DateTime createdAt;

  HabitAction copyWith({
    String? id,
    String? habitId,
    String? userId,
    HabitActionType? action,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return HabitAction(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'habit_id': habitId,
      'user_id': userId,
      'action': action.toString().split('.').last,
      'my_updated_at': updatedAt.toIso8601String(),
      'my_created_at': createdAt.toIso8601String(),
    };
  }
}
