import 'package:appwrite/models.dart' as models;
import 'package:habit_quest/common.dart';

final habitsServiceProvider =
    StateNotifierProvider<HabitsNotifier, HabitsState>((ref) {
  return HabitsNotifier(
    user: ref.watch(userServiceProvider),
  );
});

class HabitsNotifier extends StateNotifier<HabitsState> {
  HabitsNotifier({
    required this.user,
  }) : super(HabitsState.loading()) {
    if (user != null) init();
  }

  final models.User? user;

  Future<void> init() async {
    final habits = await AppRepository.getHabits();
    state = HabitsState.data(habits);
  }

  Future<void> createHabit(Habit habit) async {
    final habits = await AppRepository.createHabit(habit);
    state = HabitsState.data(habits);
  }

  Future<void> deleteHabit(Habit habit) async {
    final habits = await AppRepository.deleteHabit(habit);
    state = HabitsState.data(habits);
  }

  Future<void> pauseHabit(Habit habit) async {
    await updateHabit(habit.copyWith(paused: !habit.paused));
  }

  Future<void> updateHabit(Habit habit) async {
    final habits = await AppRepository.updateHabit(habit);
    state = HabitsState.data(habits);
  }
}
