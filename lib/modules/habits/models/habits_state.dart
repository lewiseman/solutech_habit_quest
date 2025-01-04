import 'package:habit_quest/modules/habits/models/habit_model.dart';

class HabitsState {
  const HabitsState();

  factory HabitsState.loading() => LoadingHabitsState();
  factory HabitsState.data(List<Habit> habits) => DataHabitsState(habits);

  List<Habit>? data() {
    if (this is DataHabitsState) {
      return (this as DataHabitsState).habits;
    }
    return null;
  }
}

class LoadingHabitsState extends HabitsState {}

class DataHabitsState extends HabitsState {
  const DataHabitsState(this.habits);
  final List<Habit> habits;
}
