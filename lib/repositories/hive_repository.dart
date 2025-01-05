import 'package:habit_quest/modules/habits/models/habit_model.dart';
import 'package:habit_quest/repositories/hive/hive_registrar.g.dart';
import 'package:habit_quest/repositories/models/repository_structure.dart';
import 'package:habit_quest/repositories/models/sync_entry.dart';
import 'package:habit_quest/repositories/repository.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveRepository extends StorageRepository {
  Box<Habit>? habitsBox;
  Box<SyncEntry>? syncDataBox;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapters();

    habitsBox = await Hive.openBox<Habit>('habits_box');
    syncDataBox = await Hive.openBox<SyncEntry>('syncdata_box');
  }

  @override
  Future<Habit> createHabit(Habit habit) async {
    await habitsBox?.put(habit.id, habit);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox?.put(
      syncId,
      SyncEntry(
        id: syncId,
        action: SyncAction.create,
        item: SyncItem.habit,
        itemId: habit.id,
        actionTime: DateTime.now(),
      ),
    );
    return Future.value(habit);
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

  @override
  Future<void> deleteHabit(String habitId) async {
    await habitsBox?.delete(habitId);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox?.put(
      syncId,
      SyncEntry(
        id: syncId,
        action: SyncAction.delete,
        item: SyncItem.habit,
        itemId: habitId,
        actionTime: DateTime.now(),
      ),
    );
  }

  @override
  Future<Habit> updateHabit(Habit habit) async {
    await habitsBox?.put(habit.id, habit);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox?.put(
      syncId,
      SyncEntry(
        id: syncId,
        action: SyncAction.update,
        item: SyncItem.habit,
        itemId: habit.id,
        actionTime: DateTime.now(),
      ),
    );
    return Future.value(habit);
  }

  @override
  Future<Habit?> getHabit(String id) {
    final res = habitsBox?.get(id);
    return Future.value(res);
  }
}
