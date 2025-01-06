import 'package:habit_quest/modules/habits/models/habit_action_model.dart';
import 'package:habit_quest/modules/habits/models/habit_model.dart';
import 'package:habit_quest/repositories/models/sync_entry.dart';
import 'package:hive_ce/hive.dart';

part 'hive_adapters.g.dart';

@GenerateAdapters([
  AdapterSpec<Habit>(),
  AdapterSpec<HabitFrequency>(),
  AdapterSpec<SyncEntry>(),
  AdapterSpec<SyncItem>(),
  AdapterSpec<SyncAction>(),
  AdapterSpec<HabitAction>(),
  AdapterSpec<HabitActionType>(),
])
class HiveAdapters {}
