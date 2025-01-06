import 'package:habit_quest/common.dart';

abstract class StorageRepository {
  Future<void> initialize();
  Future<void> delete();

  Future<Habit> createHabit(Habit habit);
  Future<void> createHabits(List<Habit> habits);
  Future<Habit> updateHabit(Habit habit);
  Future<void> updateHabits(List<Habit> habits);
  Future<void> deleteHabit(String habitId);
  Future<void> deleteHabits(List<String> habitIds);
  Future<List<Habit>> getHabits(String userId);
  Future<Habit?> getHabit(String id);

  ///
  Future<HabitAction> createHabitAction(HabitAction action);
  Future<void> createHabitActions(List<HabitAction> actions);
  Future<HabitAction> updateHabitAction(HabitAction action);
  Future<void> updateHabitActions(List<HabitAction> actions);
  Future<void> deleteHabitAction(String actionId);
  Future<void> deleteHabitActions(List<String> actionIds);
  Future<List<HabitAction>> getHabitActions(String userId);
  Future<HabitAction?> getHabitAction(String habitId);
}
