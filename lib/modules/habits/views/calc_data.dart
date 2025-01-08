import 'package:habit_quest/common.dart';

class HabitsCalcData {
  HabitsCalcData({
    required this.habits,
    required this.selectedDate,
    required this.habitActions,
  }) {
    habits.sort((a, b) => a.time.compareTo(b.time));
    final todaysActions = habitActions.where((action) {
      return action.createdAt.day == selectedDate.day &&
          action.createdAt.month == selectedDate.month &&
          action.createdAt.year == selectedDate.year;
    });
    final today = DateTime.now();
    final remainingHabits = () {
      if (habits.isEmpty) {
        return <Habit>[];
      }
      final remainingHabits = habits.where((habit) {
        final now = TimeOfDay.now();
        final hasPassed = habit.timeValue().compareTo(now);
        return hasPassed > 0;
      }).toList();
      final withNoActions = remainingHabits.where((habit) {
        return todaysActions.every((action) {
          return action.habitId != habit.id;
        });
      }).toList();
      if (selectedDate.day == today.day) {
        return withNoActions;
      }
      return <Habit>[];
    }();

    final actionedHabits = () {
      final withaction = habits.where((habit) {
        return habitActions.any((action) {
          return action.habitId == habit.id &&
              action.createdAt.day == selectedDate.day &&
              action.createdAt.month == selectedDate.month &&
              action.createdAt.year == selectedDate.year;
        });
      }).toList();
      return withaction;
    }();

    final actionedHabitsWithActions = () {
      final habitsAction = actionedHabits.map((habit) {
        final action = todaysActions.firstWhere((action) {
          return habit.id == action.habitId;
        });
        return (habit: habit, action: action);
      }).toList();
      return habitsAction;
    }();

    completedHabits = calcCompletedHabits(actionedHabitsWithActions);

    skippedHabits = calcSkippedHabits(actionedHabitsWithActions);

    upcomingHabits = calcUpcomingHabits(remainingHabits);

    nextHabit = calcNextHabit(remainingHabits);

    futureHabits = calcFutureHabits(today, skippedHabits);

    missedHabits = calcMissedHabits(
      upcomingHabits,
      completedHabits,
      nextHabit,
      skippedHabits,
      futureHabits,
    );
  }

  List<({HabitAction action, Habit habit})> calcCompletedHabits(
    List<({HabitAction action, Habit habit})> actionedHabitsWithActions,
  ) {
    final thehabits = actionedHabitsWithActions.where((habit) {
      return habit.action.action == HabitActionType.done;
    }).toList();
    return thehabits;
  }

  List<({HabitAction action, Habit habit})> calcSkippedHabits(
    List<({HabitAction action, Habit habit})> actionedHabitsWithActions,
  ) {
    final thehabits = actionedHabitsWithActions.where((habit) {
      return habit.action.action == HabitActionType.skipped;
    }).toList();
    return thehabits;
  }

  List<Habit> calcUpcomingHabits(List<Habit> remainingHabits) {
    if (remainingHabits.length <= 1) {
      return [];
    }
    return remainingHabits.sublist(1);
  }

  Habit? calcNextHabit(List<Habit> remainingHabits) {
    if (remainingHabits.isEmpty) {
      return null;
    }
    return remainingHabits.first;
  }

  List<Habit> calcFutureHabits(
    DateTime today,
    List<({HabitAction action, Habit habit})> skippedHabits,
  ) {
    if (selectedDate.day <= today.day) {
      return [];
    }
    final notSkipped = habits.where((habit) {
      return skippedHabits.every((action) {
        return habit.id != action.habit.id;
      });
    }).toList();
    return notSkipped;
  }

  List<Habit> calcMissedHabits(
    List<Habit>? upcomingHabits,
    List<({HabitAction action, Habit habit})> completedHabits,
    Habit? nextHabit,
    List<({HabitAction action, Habit habit})> skippedHabits,
    List<Habit>? futureHabits,
  ) {
    final filter1 = habits.where((habit) {
      final inupcoming = (upcomingHabits ?? []).any((upcoming) {
        return habit.id == upcoming.id;
      });
      return !inupcoming;
    });

    final filter2 = filter1.where((habit) {
      final incompleted = completedHabits.any((upcoming) {
        return habit.id == upcoming.habit.id;
      });
      return !incompleted;
    });

    final filter3 = filter2.where((habit) {
      return habit.id != nextHabit?.id;
    });

    final filter4 = filter3.where((habit) {
      final incompleted = skippedHabits.any((upcoming) {
        return habit.id == upcoming.habit.id;
      });
      return !incompleted;
    });

    final filter5 = filter4.where((habit) {
      final incompleted = (futureHabits ?? []).any((future) {
        return habit.id == future.id;
      });
      return !incompleted;
    });

    final res = filter5;
    return res.toList();
  }

  final List<Habit> habits;
  final DateTime selectedDate;
  final List<HabitAction> habitActions;

  late List<Habit> missedHabits;
  late List<Habit> futureHabits;
  late Habit? nextHabit;
  late List<Habit> upcomingHabits;
  late List<({HabitAction action, Habit habit})> skippedHabits;
  late List<({HabitAction action, Habit habit})> completedHabits;
}
