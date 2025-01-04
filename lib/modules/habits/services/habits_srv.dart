import 'package:appwrite/models.dart' as models;
import 'package:habit_quest/common.dart';

final habitsServiceProvider = StateNotifierProvider((ref) {
  return HabitsNotifier(
    user: ref.watch(userServiceProvider),
  );
});

class HabitsNotifier extends StateNotifier<List<Habit>> {
  HabitsNotifier({
    required this.user,
  }) : super([]) {
    if (user != null) init();
  }

  final models.User? user;

  Future<void> init() async {
    final habits = await AppRepository.getHabits();
    state = habits;
  }

  Future<void> createHabit(Habit habit) async {
    final habits = AppRepository.createHabit(habit);
    state = habits;
  }
}
