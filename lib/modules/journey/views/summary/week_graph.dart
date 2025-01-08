import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habit_quest/config/config.dart';
import 'package:intl/intl.dart';

class SummaryWeekGraph extends StatefulWidget {
  const SummaryWeekGraph({required this.data, required this.theme, super.key});
  final ({
    Map<String, double> bar,
    DateTime start,
    DateTime end,
    double avg
  }) data;
  final ThemeData theme;

  @override
  State<SummaryWeekGraph> createState() => _SummaryWeekGraphState();
}

class _SummaryWeekGraphState extends State<SummaryWeekGraph> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.theme.cardColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: widget.theme.shadowColor.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'WEEKLY PROGRESS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppTheme.poppinsFont,
                        ),
                      ),
                      Text(
                        '''${DateFormat.yMMMd().format(widget.data.start).toUpperCase()} - ${DateFormat.yMMMd().format(widget.data.end).toUpperCase()}''',
                        style: TextStyle(
                          color: widget.theme.textTheme.bodyMedium!.color!
                              .withOpacity(.7),
                          fontFamily: AppTheme.poppinsFont,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'AVG',
                      style: TextStyle(
                        color: widget.theme.textTheme.bodyMedium!.color!
                            .withOpacity(.7),
                        fontFamily: AppTheme.poppinsFont,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.data.avg.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppTheme.primaryBlue,
                        fontFamily: AppTheme.poppinsFont,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BarChart(
              mainBarData(),
            ),
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
              case 1:
                weekDay = 'Tuesday';
              case 2:
                weekDay = 'Wednesday';
              case 3:
                weekDay = 'Thursday';
              case 4:
                weekDay = 'Friday';
              case 5:
                weekDay = 'Saturday';
              case 6:
                weekDay = 'Sunday';
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(),
        topTitles: const AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
      case 1:
        text = const Text('T', style: style);
      case 2:
        text = const Text('W', style: style);
      case 3:
        text = const Text('T', style: style);
      case 4:
        text = const Text('F', style: style);
      case 5:
        text = const Text('S', style: style);
      case 6:
        text = const Text('S', style: style);
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(
        7,
        (i) {
          switch (i) {
            case 0:
              return makeGroupData(
                0,
                widget.data.bar['Mon'] ?? 0,
                isTouched: i == touchedIndex,
              );
            case 1:
              return makeGroupData(
                1,
                widget.data.bar['Tue'] ?? 0,
                isTouched: i == touchedIndex,
              );
            case 2:
              return makeGroupData(
                2,
                widget.data.bar['Wed'] ?? 0,
                isTouched: i == touchedIndex,
              );
            case 3:
              return makeGroupData(
                3,
                widget.data.bar['Thu'] ?? 0,
                isTouched: i == touchedIndex,
              );
            case 4:
              return makeGroupData(
                4,
                widget.data.bar['Fri'] ?? 0,
                isTouched: i == touchedIndex,
              );
            case 5:
              return makeGroupData(
                5,
                widget.data.bar['Sat'] ?? 0,
                isTouched: i == touchedIndex,
              );
            case 6:
              return makeGroupData(
                6,
                widget.data.bar['Sun'] ?? 0,
                isTouched: i == touchedIndex,
              );
            default:
              return throw Error();
          }
        },
      );

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    final barColor = isTouched ? Colors.pink : AppTheme.primaryBlue;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.pink.shade800)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: AppTheme.primaryBlue.withOpacity(0.2),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }
}
