// ignore_for_file: unused_result

import 'package:appwrite/models.dart' as models;
import 'package:habit_quest/common.dart';

final habitsServiceProvider =
    StateNotifierProvider<HabitsNotifier, HabitsState>((ref) {
  return HabitsNotifier(
    user: ref.watch(userServiceProvider),
    ref: ref,
  );
});

class HabitsNotifier extends StateNotifier<HabitsState> {
  HabitsNotifier({
    required this.user,
    required this.ref,
  }) : super(HabitsState.loading()) {
    if (user != null) init();
  }

  final models.User? user;
  final Ref ref;

  Future<void> init() async {
    final habits = await AppRepository.getHabits(user!.$id);
    state = HabitsState.data(habits);
    ref.refresh(notificationsServiceProvider);
  }

  void updateFromSync(List<Habit> habits) {
    state = HabitsState.data(habits);
    ref.refresh(notificationsServiceProvider);
  }

  Future<void> createHabit(Habit habit) async {
    final habits = await AppRepository.createHabit(habit);
    state = HabitsState.data(habits);
    ref.refresh(notificationsServiceProvider);
  }

  Future<void> deleteHabit(Habit habit) async {
    final habits = await AppRepository.deleteHabit(habit);
    state = HabitsState.data(habits);
    ref.refresh(notificationsServiceProvider);
  }

  Future<void> pauseHabit(Habit habit) async {
    await updateHabit(habit.copyWith(paused: !habit.paused));
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await AppRepository.updateHabit(
      habit.copyWith(notificationId: Habit.generateNotificationId()),
    );
    state = HabitsState.data(habits);
    ref.refresh(notificationsServiceProvider);
  }
}
