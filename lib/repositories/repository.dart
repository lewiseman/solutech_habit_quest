import 'package:habit_quest/common.dart';

final class AppRepository {
  factory AppRepository() => _instance;
  AppRepository._();
  static final AppRepository _instance = AppRepository._();
  static AppRepository get instance => _instance;

  static String getUniqueID() {
    return ID.unique();
  }

  static Future<List<Habit>> getHabits() async {
    return [];
  }

  static List<Habit> createHabit(Habit habit) {
    print('Creating habit: $habit');
    return [];
  }
}
