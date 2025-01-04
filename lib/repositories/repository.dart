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
    final xx =await instance.localRepository.getHabits();
    return xx;
    // try {
    //   final res = await instance.remoteRepository.getHabits();
    //   return res;
    // } catch (e) {
    //   rethrow;
    // }
  }

  static Future<List<Habit>> createHabit(Habit habit) async {
    final res = await instance.localRepository.createHabit(habit);
    return [];
  }

  static Future<List<Habit>> updateHabit(Habit habit) async {
    await instance.remoteRepository.updateHabit(habit);
    return [];
  }

  static Future<List<Habit>> deleteHabit(Habit habit) async {
    await instance.remoteRepository.deleteHabit(habit);
    return [];
  }
}
