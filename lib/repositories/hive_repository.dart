import 'package:habit_quest/modules/habits/models/habit_model.dart';
import 'package:habit_quest/repositories/repository_structure.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveRepository extends StorageRepository {
  Box<Habit>? habitsBox;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    habitsBox = await Hive.openBox<Habit>('habits_box');
  }

  @override
  Future<Habit> createHabit(Habit habit) {
    habitsBox?.put(habit.id, habit);
    return Future.value(habit);
    // // TODO: implement createHabit
    // throw UnimplementedError();
  }

  @override
  Future<void> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Habit>> getHabits() {
    final habits = habitsBox?.values.toList();
    return Future.value(habits);
  }
}
