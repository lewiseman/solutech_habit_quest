import 'package:habit_quest/common.dart';

class JourneySummaryData {
  const JourneySummaryData({
    required this.habits,
    required this.habitActions,
  });
  final List<Habit> habits;
  final List<HabitAction> habitActions;

  ({
    String overallStreak,
    String habitsFinished,
    String completionRate,
    String perfectDays
  }) statsCardData() {
    final overallStreak = calculateOverallStreak(habitActions);
    final habitsFinished = habitActions
        .where((action) => action.action == HabitActionType.done)
        .length;

    final completionRate =
        calculateOverallCompletionRate(habits, habitActions).maxPercentage;
    final perfectDays = calculatePerfectDays(habits, habitActions);
    return (
      overallStreak: '$overallStreak',
      habitsFinished: '$habitsFinished',
      completionRate: '${completionRate.toStringAsFixed(0)}%',
      perfectDays: '$perfectDays'
    );
  }

  ({Map<String, double> bar, DateTime start, DateTime end, double avg})
      weekData() {
    final bardata = calculateWeeklyBarData(habits, habitActions);
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    final endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday
    final avg = calculateWeeksAverage(bardata);
    return (bar: bardata, start: startOfWeek, end: endOfWeek, avg: avg);
  }

  ({String activeDay, int habitsCompleted, int habitsCompletedThisWeek})
      textSummaryData() {
    final activeDay = calculateMostActiveDay(habitActions);
    final habitsCompleted = calculateTotalHabitsCompletedThisMonth(
      habits,
      habitActions,
    );
    final habitsCompletedThisWeek = calculateTotalHabitsCompletedThisWeek(
      habits,
      habitActions,
    );
    return (
      activeDay: activeDay,
      habitsCompleted: habitsCompleted,
      habitsCompletedThisWeek: habitsCompletedThisWeek
    );
  }

  String calculateMostActiveDay(List<HabitAction> actions) {
    final dayCounts = <String, int>{
      'Sunday': 0,
      'Monday': 0,
      'Tuesday': 0,
      'Wednesday': 0,
      'Thursday': 0,
      'Friday': 0,
      'Saturday': 0,
    };

    for (final action in actions) {
      final weekdayName = _weekdayName(action.createdAt.weekday);
      dayCounts[weekdayName] = (dayCounts[weekdayName] ?? 0) + 1;
    }

    // Find the day with the highest count
    final res = dayCounts.entries.reduce((a, b) => a.value > b.value ? a : b);
    if (res.value == 0) return 'N/A';
    return res.key;
  }

  int calculateTotalHabitsCompletedThisWeek(
    List<Habit> habits,
    List<HabitAction> actions,
  ) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final thisWeekActions = actions.where(
      (action) =>
          action.createdAt.isAfter(startOfWeek) &&
          action.createdAt.isBefore(endOfWeek.add(const Duration(days: 1))),
    );

    final habitIdsCompleted = <String>{};

    for (final action in thisWeekActions) {
      habitIdsCompleted.add(action.habitId);
    }

    return habitIdsCompleted.length;
  }

  int calculateTotalHabitsCompletedThisMonth(
    List<Habit> habits,
    List<HabitAction> actions,
  ) {
    final now = DateTime.now();
    final thisMonthActions = actions.where(
      (action) =>
          action.createdAt.year == now.year &&
          action.createdAt.month == now.month,
    );

    final habitIdsCompleted = <String>{};

    for (final action in thisMonthActions) {
      habitIdsCompleted.add(action.habitId);
    }

    return habitIdsCompleted.length;
  }

  int calculateOverallStreak(List<HabitAction> actions) {
    // Group actions by date (remove time component for grouping)
    final actionsByDate = <String, int>{};

    for (final action in actions) {
      final date =
          action.createdAt.toLocal().toIso8601String().split('T').first;
      actionsByDate.update(date, (count) => count + 1, ifAbsent: () => 1);
    }

    // Sort dates in descending order
    final sortedDates = actionsByDate.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    // Calculate streak
    var streak = 0;
    DateTime? previousDate;

    for (final dateString in sortedDates) {
      final currentDate = DateTime.parse(dateString);

      if (previousDate == null ||
          previousDate
              .subtract(const Duration(days: 1))
              .isAtSameMomentAs(currentDate)) {
        streak++;
        previousDate = currentDate;
      } else {
        break; // Gap found; streak ends
      }
    }

    return streak;
  }

  double calculateOverallCompletionRate(
    List<Habit> habits,
    List<HabitAction> actions,
  ) {
    final now = DateTime.now();
    var totalExpectedActions = 0;
    final totalCompletedActions = actions.length;

    for (final habit in habits) {
      final daysSinceStart =
          now.difference(habit.startDate).inDays + 1; // +1 includes today
      switch (habit.frequency) {
        case HabitFrequency.daily:
          totalExpectedActions += daysSinceStart;
        case HabitFrequency.weekly:
          totalExpectedActions += (daysSinceStart / 7).ceil();
        case HabitFrequency.once:
          totalExpectedActions += 1;
      }
    }

    // Avoid division by zero
    if (totalExpectedActions == 0) return 0;

    return (totalCompletedActions / totalExpectedActions) * 100;
  }

  int calculatePerfectDays(List<Habit> habits, List<HabitAction> actions) {
    final actionsByDate = <String, Set<String>>{};

    for (final action in actions) {
      final date =
          action.createdAt.toLocal().toIso8601String().split('T').first;
      actionsByDate.putIfAbsent(date, () => {}).add(action.habitId);
    }

    var perfectDays = 0;

    for (final date in actionsByDate.keys) {
      if (habits.every((habit) => actionsByDate[date]!.contains(habit.id))) {
        perfectDays++;
      }
    }

    return perfectDays;
  }

  Map<String, double> calculateWeeklyBarData(
    List<Habit> habits,
    List<HabitAction> actions,
  ) {
    // Define week range (Monday to Sunday)
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1)); // Monday
    final endOfWeek = startOfWeek.add(const Duration(days: 6)); // Sunday

    // Initialize map with default values for each day
    final weeklyData = <String, double>{
      'Sun': 0.0,
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
    };

    // Group actions by day
    final actionsByDay = <String, List<HabitAction>>{};

    for (final action in actions) {
      if (action.createdAt.isAfter(startOfWeek) &&
          action.createdAt.isBefore(endOfWeek.add(const Duration(days: 1)))) {
        final day = action.createdAt.weekday; // 1=Mon, ..., 7=Sun
        final dayName = _weekdayName(day);
        actionsByDay.putIfAbsent(dayName, () => []).add(action);
      }
    }

    // Calculate averages
    for (var i = 0; i < 7; i++) {
      final currentDay = startOfWeek.add(Duration(days: i));
      final dayName = _weekdayName(currentDay.weekday);

      final habitsForDay = habits.where((habit) {
        // Check if the habit is active on this day
        if (habit.frequency == HabitFrequency.daily) return true;
        if (habit.frequency == HabitFrequency.weekly)
          return habit.days?.contains(dayName) ?? false;
        if (habit.frequency == HabitFrequency.once)
          return habit.startDate.isAtSameMomentAs(currentDay);
        return false;
      }).toList();

      final actionsForDay = actionsByDay[dayName] ?? [];

      if (habitsForDay.isNotEmpty) {
        weeklyData[dayName] = actionsForDay.length / habitsForDay.length;
      }
    }

    return weeklyData;
  }

  String _weekdayName(int weekday) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[weekday % 7];
  }

  double calculateWeeksAverage(Map<String, double> weeklyData) {
    // Filter out days with 0.0 (no active habits or no actions)
    final nonZeroValues =
        weeklyData.values.where((value) => value > 0).toList();

    if (nonZeroValues.isEmpty) return 0; // Avoid division by zero

    // Calculate the average
    final sum = nonZeroValues.reduce((a, b) => a + b);
    return sum / nonZeroValues.length;
  }

  Map<DateTime, Color> calculateColorGrid() {
    // Map to store completion rates and corresponding colors
    final completionRates = <DateTime, double>{};
    final colorGrid = <DateTime, Color>{};

    // Get unique dates from HabitAction and include ongoing habit days
    final allDates = <DateTime>{};

    for (final action in habitActions) {
      allDates.add(action.createdAt);
    }

    final now = DateTime.now();
    for (final habit in habits) {
      if (habit.frequency == HabitFrequency.daily) {
        for (var date = habit.startDate;
            date.isBefore(now) || date.isAtSameMomentAs(now);
            date = date.add(const Duration(days: 1))) {
          allDates.add(DateTime(date.year, date.month, date.day));
        }
      } else if (habit.frequency == HabitFrequency.weekly &&
          habit.days != null) {
        for (final day in habit.days!) {
          final dayIndex = _weekdayIndex(day);
          for (var date = habit.startDate;
              date.isBefore(now) || date.isAtSameMomentAs(now);
              date = date.add(const Duration(days: 1))) {
            if (date.weekday == dayIndex) {
              allDates.add(DateTime(date.year, date.month, date.day));
            }
          }
        }
      }
    }

    // Calculate completion rates for each date
    for (final date in allDates) {
      final habitsForDay = habits.where((habit) {
        if (habit.frequency == HabitFrequency.daily) return true;
        if (habit.frequency == HabitFrequency.weekly) {
          final weekdayName = _weekdayName(date.weekday);
          return habit.days?.contains(weekdayName) ?? false;
        }
        if (habit.frequency == HabitFrequency.once) {
          return habit.startDate.isAtSameMomentAs(date);
        }
        return false;
      }).toList();

      final actionsForDay = habitActions.where((action) {
        final actionDate = DateTime(
          action.createdAt.year,
          action.createdAt.month,
          action.createdAt.day,
        );
        return actionDate.isAtSameMomentAs(date);
      }).toList();

      if (habitsForDay.isNotEmpty) {
        final completionRate = actionsForDay.length / habitsForDay.length;
        completionRates[date] = completionRate;

        // Map completion rate to a shade of green
        final color = _getShadeOfGreen(completionRate);
        // const color = Colors.yellow;
        colorGrid[date] = color;
      } else {
        completionRates[date] = 0.0;
        colorGrid[date] =
            Colors.green.shade100; // Default color for inactive days
      }
    }

    return colorGrid;
  }

  int _weekdayIndex(String day) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days.indexOf(day) +
        1; // Convert to weekday index (1 = Monday, 7 = Sunday)
  }

  Color _getShadeOfGreen(double completionRate) {
    final greenValue = (255 * completionRate).toInt();
    return Color.fromARGB(255, 0, greenValue, 0);
  }
}
