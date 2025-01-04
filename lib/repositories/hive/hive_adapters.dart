import 'package:habit_quest/modules/habits/models/habit_model.dart';
import 'package:hive_ce/hive.dart';

@GenerateAdapters([
  AdapterSpec<Habit>(),
])

class HiveAdapters {}
