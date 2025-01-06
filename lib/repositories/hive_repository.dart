import 'package:habit_quest/modules/habits/models/habit_action_model.dart';
import 'package:habit_quest/modules/habits/models/habit_model.dart';
import 'package:habit_quest/repositories/hive/hive_registrar.g.dart';
import 'package:habit_quest/repositories/models/repository_structure.dart';
import 'package:habit_quest/repositories/models/sync_entry.dart';
import 'package:habit_quest/repositories/repository.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveRepository extends StorageRepository {
  late Box<Habit> habitsBox;
  late Box<SyncEntry> syncDataBox;
  late Box<HabitAction> habitActionsBox;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapters();

    habitsBox = await Hive.openBox<Habit>('habits_box');
    syncDataBox = await Hive.openBox<SyncEntry>('syncdata_box');
    habitActionsBox = await Hive.openBox<HabitAction>('habit_actions_box');
  }

  @override
  Future<Habit> createHabit(Habit habit) async {
    await habitsBox.put(habit.id, habit);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox.put(
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
  Future<void> delete() async {
    await habitsBox.clear();
    await syncDataBox.clear();
  }

  @override
  Future<List<Habit>> getHabits(String userId) {
    final habits = habitsBox.values.toList();
    return Future.value(habits);
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await habitsBox.delete(habitId);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox.put(
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
    await habitsBox.put(habit.id, habit);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox.put(
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
    final res = habitsBox.get(id);
    return Future.value(res);
  }

  @override
  Future<void> createHabits(List<Habit> habits) async {
    await habitsBox.putAll({for (final habit in habits) habit.id: habit});
  }

  @override
  Future<void> deleteHabits(List<String> habitIds) async {
    await habitsBox.deleteAll(habitIds);
  }

  @override
  Future<void> updateHabits(List<Habit> habits) {
    return createHabits(habits);
  }

  @override
  Future<HabitAction> createHabitAction(HabitAction action) async {
    await habitActionsBox.put(action.id, action);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox.put(
      syncId,
      SyncEntry(
        id: syncId,
        action: SyncAction.create,
        item: SyncItem.habitActivity,
        itemId: action.id,
        actionTime: DateTime.now(),
      ),
    );
    return Future.value(action);
  }

  @override
  Future<void> createHabitActions(List<HabitAction> actions) async {
    await habitActionsBox.putAll({
      for (final action in actions) action.id: action,
    });
  }

  @override
  Future<void> deleteHabitAction(String actionId) async {
    await habitActionsBox.delete(actionId);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox.put(
      syncId,
      SyncEntry(
        id: syncId,
        action: SyncAction.delete,
        item: SyncItem.habitActivity,
        itemId: actionId,
        actionTime: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> deleteHabitActions(List<String> actionIds) {
    // TODO: implement deleteActions
    throw UnimplementedError();
  }

  @override
  Future<HabitAction> updateHabitAction(HabitAction action) async {
    await habitActionsBox.put(action.id, action);
    final syncId = AppRepository.getUniqueID();
    await syncDataBox.put(
      syncId,
      SyncEntry(
        id: syncId,
        action: SyncAction.update,
        item: SyncItem.habitActivity,
        itemId: action.id,
        actionTime: DateTime.now(),
      ),
    );
    return Future.value(action);
  }

  @override
  Future<void> updateHabitActions(List<HabitAction> actions) {
    // TODO: implement updateActions
    throw UnimplementedError();
  }

  @override
  Future<List<HabitAction>> getHabitActions(String userId) async {
    return habitActionsBox.values
        .where((element) => element.userId == userId)
        .toList();
  }

  @override
  Future<HabitAction?> getHabitAction(String habitId) async {
    final res = habitActionsBox.get(habitId);
    return Future.value(res);
  }
}
