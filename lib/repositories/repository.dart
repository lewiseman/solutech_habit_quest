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

  static Future<List<Habit>> getHabits() async {
    return instance.localRepository.getHabits();
  }

  static Future<List<Habit>> createHabit(Habit habit) async {
    await instance.localRepository.createHabit(habit);
    final updatedLocal = await instance.localRepository.getHabits();

    return updatedLocal;
  }

  static Future<List<Habit>> updateHabit(Habit habit) async {
    await instance.localRepository.updateHabit(habit);
    // await instance.remoteRepository.updateHabit(habit);
    final updatedLocal = await instance.localRepository.getHabits();

    return updatedLocal;
  }

  static Future<List<Habit>> deleteHabit(Habit habit) async {
    await instance.localRepository.deleteHabit(habit.id);
    // await instance.remoteRepository.deleteHabit(habit);
    final updatedLocal = await instance.localRepository.getHabits();

    return updatedLocal;
  }
}
