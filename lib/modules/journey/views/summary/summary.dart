import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/journey/views/summary/week_graph.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 200),
      child: Column(
        children: [
          SizedBox(height: 30),
          StatsCard(),
          SizedBox(height: 40),
          SummaryWeekGraph(),
          SizedBox(height: 40),
          SummaryMonthTable(),
          SizedBox(height: 40),
          TextSummary(),
        ],
      ),
    );
  }
}

class SummaryMonthTable extends StatelessWidget {
  const SummaryMonthTable({
    super.key,
  });

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
                          return Colors.green.shade300;
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
    super.key,
  });

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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GENERAL',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: AppTheme.poppinsFont,
            ),
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                  'MONDAY',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          Divider(
            thickness: .1,
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                  '3',
                  style: TextStyle(
                    fontFamily: AppTheme.poppinsFont,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          Divider(
            thickness: .1,
            height: 30,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                  '1',
                  style: TextStyle(
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
    super.key,
  });

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
        final data = _coloredCards[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: data.color,
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
                      data.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: AppTheme.poppinsFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Icon(
                    data.icon,
                    color: Colors.white,
                  ),
                ],
              ),
              Text(
                data.value,
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
    value: '2',
    icon: CustomIcons.fireworks,
  ),
  (
    color: Colors.green,
    title: 'HABIT\nFINISHED',
    value: '12',
    icon: CustomIcons.running,
  ),
  (
    color: Colors.purple,
    title: 'COMPLETION\nRATE',
    value: '25%',
    icon: CustomIcons.progression,
  ),
  (
    color: Colors.yellow.shade800,
    title: 'PERFECT\nDAYS',
    value: '3',
    icon: CustomIcons.ok,
  ),
];
