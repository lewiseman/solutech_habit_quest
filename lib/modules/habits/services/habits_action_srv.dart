import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/user/models/quest_user.dart';

final habitsActionServiceProvider =
    StateNotifierProvider<HabitsActionNotifier, List<HabitAction>>((ref) {
  return HabitsActionNotifier(
    user: ref.watch(authServiceProvider),
  );
});

class HabitsActionNotifier extends StateNotifier<List<HabitAction>> {
  HabitsActionNotifier({required this.user}) : super([]) {
    if (user != null) init();
  }

  final QuestUser? user;

  Future<void> init() async {
    final habitactions = await AppRepository.getHabitActions(user!.id);
    state = habitactions;
  }

  Future<void> sendCompleteAction(Habit habit) async {
    final action = HabitAction(
      id: AppRepository.getUniqueID(),
      habitId: habit.id,
      userId: user!.id,
      action: HabitActionType.done,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final actions = await AppRepository.createHabitAction(action);
    state = actions;
  }

  Future<void> undoCompletedAction(HabitAction action) async {
    final actions = await AppRepository.deleteHabitAction(action);
    state = actions;
  }

  Future<void> skipAction(HabitAction action) async {
    final actions = await AppRepository.updateHabitAction(
      action.copyWith(
        action: HabitActionType.skipped,
        updatedAt: DateTime.now(),
      ),
    );
    state = actions;
  }

  Future<void> skipToCompletion(HabitAction action) async {
    final actions = await AppRepository.updateHabitAction(
      action.copyWith(
        action: HabitActionType.done,
        updatedAt: DateTime.now(),
      ),
    );
    state = actions;
  }

  Future<void> createSkipAction(Habit habit) async {
    final action = HabitAction(
      id: AppRepository.getUniqueID(),
      habitId: habit.id,
      userId: user!.id,
      action: HabitActionType.skipped,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final actions = await AppRepository.createHabitAction(action);
    state = actions;
  }

  Future<void> skipFutureAction(Habit habit, DateTime date) async {
    final action = HabitAction(
      id: AppRepository.getUniqueID(),
      habitId: habit.id,
      userId: user!.id,
      action: HabitActionType.skipped,
      createdAt: date,
      updatedAt: DateTime.now(),
    );
    final actions = await AppRepository.createHabitAction(action);
    state = actions;
  }

  void updateFromSync(List<HabitAction> habitActions) {
    state = habitActions;
    print('HabitActions updated');
  }
}
