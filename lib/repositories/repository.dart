import 'package:habit_quest/common.dart';
import 'package:habit_quest/repositories/appwrite_repository.dart';
import 'package:habit_quest/repositories/hive_repository.dart';

final class AppRepository {
  factory AppRepository() => _instance;
  AppRepository._();
  static final AppRepository _instance = AppRepository._();
  static AppRepository get instance => _instance;
  final remoteRepository = AppwriteRepository();
  final localRepository = HiveRepository();

  static Future<void> initialize() async {
    await instance.localRepository.initialize();
  }

  static String getUniqueID() {
    return ID.unique();
  }

  static Future<List<Habit>> getHabits(String userId) async {
    return instance.localRepository.getHabits(userId);
  }

  static Future<List<Habit>> createHabit(Habit habit) async {
    await instance.localRepository.createHabit(habit);
    final updatedLocal = await instance.localRepository.getHabits(habit.userId);

    return updatedLocal;
  }

  static Future<List<Habit>> updateHabit(Habit habit) async {
    await instance.localRepository.updateHabit(habit);
    final updatedLocal = await instance.localRepository.getHabits(habit.userId);

    return updatedLocal;
  }

  static Future<List<Habit>> deleteHabit(Habit habit) async {
    await instance.localRepository.deleteHabit(habit.id);
    final updatedLocal = await instance.localRepository.getHabits(habit.userId);

    return updatedLocal;
  }

  ///
  ///

  static Future<List<HabitAction>> getHabitActions(String userId) async {
    return instance.localRepository.getHabitActions(userId);
  }

  static Future<List<HabitAction>> createHabitAction(HabitAction action) async {
    await instance.localRepository.createHabitAction(action);
    final updatedLocal =
        await instance.localRepository.getHabitActions(action.userId);
    return updatedLocal;
  }

  static Future<List<HabitAction>> deleteHabitAction(HabitAction action) async {
    await instance.localRepository.deleteHabitAction(action.id);
    final updatedLocal =
        await instance.localRepository.getHabitActions(action.userId);
    return updatedLocal;
  }

  static Future<List<HabitAction>> updateHabitAction(HabitAction action) async {
    await instance.localRepository.updateHabitAction(action);
    final updatedLocal =
        await instance.localRepository.getHabitActions(action.userId);
    return updatedLocal;
  }

  Future<void> clear() async {
    await instance.localRepository.delete();
  }
}
