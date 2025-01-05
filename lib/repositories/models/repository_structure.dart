import 'package:habit_quest/common.dart';

abstract class StorageRepository {
  Future<void> initialize();
  Future<void> delete();

  Future<Habit> createHabit(Habit habit);
  Future<Habit> updateHabit(Habit habit);
  Future<void> deleteHabit(String habitId);
  Future<List<Habit>> getHabits();
  Future<Habit?> getHabit(String id);
}
