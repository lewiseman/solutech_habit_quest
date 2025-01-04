import 'package:habit_quest/common.dart';

abstract class StorageRepository {
  Future<void> initialize();
  Future<void> delete();
  Future<Habit> createHabit(Habit habit);
  Future<List<Habit>> getHabits();
}
