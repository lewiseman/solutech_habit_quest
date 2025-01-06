import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/journey/views/summary/calc_data.dart';
import 'package:habit_quest/modules/journey/views/summary/week_graph.dart';

class SummarySection extends ConsumerWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsState = ref.watch(habitsServiceProvider);
    final habits = () {
      if (habitsState is DataHabitsState) {
        return habitsState.habits;
      }
      return <Habit>[];
    }();
    final habitActions = ref.watch(habitsActionServiceProvider);
    final data = JourneySummaryData(habits: habits, habitActions: habitActions);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 200),
      child: Column(
        children: [
          const SizedBox(height: 30),
          StatsCard(
            data: data.statsCardData(),
          ),
          const SizedBox(height: 40),
          SummaryWeekGraph(
            data: data.weekData(),
          ),
          const SizedBox(height: 40),
          SummaryMonthTable(
            dates: data.calculateColorGrid(),
          ),
          const SizedBox(height: 40),
          TextSummary(
            data: data.textSummaryData(),
          ),
        ],
      ),
    );
  }
}

class SummaryMonthTable extends StatelessWidget {
  const SummaryMonthTable({
    required this.dates,
    super.key,
  });
  final Map<DateTime, Color> dates;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MONTHLY PROGRESS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: CalendarCarousel(
              todayBorderColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              weekdayTextStyle: const TextStyle(
                color: Colors.black,
                fontFamily: AppTheme.poppinsFont,
              ),
              customDayBuilder: (
                isSelectable,
                index,
                isSelectedDay,
                isToday,
                isPrevMonthDay,
                textStyle,
                isNextMonthDay,
                isThisMonthDay,
                day,
              ) {
                final today = DateTime.now();
                final dayColor =
                    dates[DateTime(day.year, day.month, day.day)] ??
                        Colors.transparent;
                return Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: () {
                        if (isToday) {
                          return AppTheme.primaryBlue;
                        } else if (isPrevMonthDay || isNextMonthDay) {
                          return Colors.grey.shade100;
                        } else if (day.isAfter(today)) {
                          return Colors.transparent;
                        } else {
                          return dayColor;
                        }
                      }(),
                      borderRadius: BorderRadius.circular(6),
                      border: (day.isAfter(today) && !isNextMonthDay)
                          ? Border.all(color: Colors.grey.shade200)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TextSummary extends StatelessWidget {
  const TextSummary({
    required this.data,
    super.key,
  });

  final ({
    String activeDay,
    int habitsCompleted,
    int habitsCompletedThisWeek
  }) data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'GENERAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Most active day  ',
                  style: TextStyle(
                    // color: Colors.grey.shade600,
                    fontFamily: AppTheme.poppinsFont,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data.activeDay,
                  style: const TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: .1,
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Total Habits Completed This Month      ',
                  style: TextStyle(
                    // color: Colors.grey.shade600,
                    fontFamily: AppTheme.poppinsFont,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data.habitsCompleted.toString(),
                  style: const TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: .1,
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 2,
                child: Text(
                  'Total Habits Completed This Week      ',
                  style: TextStyle(
                    // color: Colors.grey.shade600,
                    fontFamily: AppTheme.poppinsFont,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  data.habitsCompletedThisWeek.toString(),
                  style: const TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  const StatsCard({
    required this.data,
    super.key,
  });

  final ({
    String completionRate,
    String overallStreak,
    String habitsFinished,
    String perfectDays
  }) data;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.6,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final cardStyle = _coloredCards[index];
        final value = () {
          switch (index) {
            case 0:
              return data.overallStreak;
            case 1:
              return data.habitsFinished;
            case 2:
              return data.completionRate;
            case 3:
              return data.perfectDays;
            default:
              return '';
          }
        }();
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardStyle.color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      cardStyle.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: AppTheme.poppinsFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    cardStyle.icon,
                    color: Colors.white,
                  ),
                ],
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: AppTheme.poppinsFont,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final _coloredCards = [
  (
    color: AppTheme.primaryBlue,
    title: 'CURRENT\nSTREAK',
    icon: CustomIcons.fireworks,
  ),
  (
    color: Colors.green,
    title: 'HABITS\nFINISHED',
    icon: CustomIcons.running,
  ),
  (
    color: Colors.purple,
    title: 'COMPLETION\nRATE',
    icon: CustomIcons.progression,
  ),
  (
    color: Colors.yellow.shade800,
    title: 'PERFECT\nDAYS',
    icon: CustomIcons.ok,
  ),
];
