import 'package:flutter/material.dart';
import 'package:habit_quest/components/calendar_carousel/calendar_carousel.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.headerTitle,
    required this.showHeader,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
    super.key,
    this.headerMargin,
    this.headerTextStyle,
    this.showHeaderButtons = true,
    this.headerIconColor,
    this.leftButtonIcon,
    this.rightButtonIcon,
    this.onHeaderTitlePressed,
  }) : isTitleTouchable = onHeaderTitlePressed != null;

  final String headerTitle;
  final EdgeInsetsGeometry? headerMargin;
  final bool showHeader;
  final TextStyle? headerTextStyle;
  final bool showHeaderButtons;
  final Color? headerIconColor;
  final Widget? leftButtonIcon;
  final Widget? rightButtonIcon;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;
  final bool isTitleTouchable;
  final VoidCallback? onHeaderTitlePressed;

  TextStyle get getTextStyle => headerTextStyle ?? defaultHeaderTextStyle;

  Widget _leftButton() => IconButton(
        onPressed: onLeftButtonPressed,
        icon:
            leftButtonIcon ?? Icon(Icons.chevron_left, color: headerIconColor),
      );

  Widget _rightButton() => IconButton(
        onPressed: onRightButtonPressed,
        icon: rightButtonIcon ??
            Icon(Icons.chevron_right, color: headerIconColor),
      );

  Widget _headerTouchable() => TextButton(
        onPressed: onHeaderTitlePressed,
        child: Text(
          headerTitle,
          semanticsLabel: headerTitle,
          style: getTextStyle,
        ),
      );

  @override
  Widget build(BuildContext context) => showHeader
      ? Container(
          margin: headerMargin,
          child: DefaultTextStyle(
            style: getTextStyle,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (showHeaderButtons) _leftButton() else Container(),
                if (isTitleTouchable)
                  _headerTouchable()
                else
                  Text(headerTitle, style: getTextStyle),
                if (showHeaderButtons) _rightButton() else Container(),
              ],
            ),
          ),
        )
      : Container();
}

const TextStyle defaultHeaderTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.blue,
);
const TextStyle defaultPrevDaysTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 14,
);
const TextStyle defaultNextDaysTextStyle = TextStyle(
  color: Colors.grey,
  fontSize: 14,
);
const TextStyle defaultDaysTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 14,
);
const TextStyle defaultTodayTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);
const TextStyle defaultSelectedDayTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
);
const TextStyle defaultWeekdayTextStyle = TextStyle(
  color: Colors.deepOrange,
  fontSize: 14,
);
const TextStyle defaultWeekendTextStyle = TextStyle(
  color: Colors.pinkAccent,
  fontSize: 14,
);
const TextStyle defaultInactiveDaysTextStyle = TextStyle(
  color: Colors.black38,
  fontSize: 14,
);
final TextStyle defaultInactiveWeekendTextStyle = TextStyle(
  color: Colors.pinkAccent.withOpacity(0.6),
  fontSize: 14,
);
final Widget defaultMarkedDateWidget = Container(
  margin: const EdgeInsets.symmetric(horizontal: 1),
  color: Colors.blueAccent,
  height: 4,
  width: 4,
);

class WeekdayRow extends StatelessWidget {
  const WeekdayRow(
    this.firstDayOfWeek,
    this.customWeekdayBuilder, {
    required this.showWeekdays,
    required this.weekdayFormat,
    required this.weekdayMargin,
    required this.weekdayPadding,
    required this.weekdayBackgroundColor,
    required this.weekdayTextStyle,
    required this.localeDate,
    super.key,
  });

  final WeekdayBuilder? customWeekdayBuilder;
  final bool showWeekdays;
  final WeekdayFormat weekdayFormat;
  final EdgeInsets weekdayMargin;
  final EdgeInsets weekdayPadding;
  final Color weekdayBackgroundColor;
  final TextStyle? weekdayTextStyle;
  final DateFormat localeDate;
  final int firstDayOfWeek;

  Widget _weekdayContainer(int weekday, String weekDayName) {
    final customWeekdayBuilder = this.customWeekdayBuilder;
    return customWeekdayBuilder != null
        ? customWeekdayBuilder(weekday, weekDayName)
        : Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: weekdayBackgroundColor),
                color: weekdayBackgroundColor,
              ),
              margin: weekdayMargin,
              padding: weekdayPadding,
              child: Center(
                child: DefaultTextStyle(
                  style: defaultWeekdayTextStyle,
                  child: Text(
                    weekDayName,
                    semanticsLabel: weekDayName,
                    style: weekdayTextStyle,
                  ),
                ),
              ),
            ),
          );
  }

  List<Widget> _renderWeekDays() {
    final list = <Widget>[];

    for (var i = firstDayOfWeek, count = 0;
        count < 7;
        i = (i + 1) % 7, count++) {
      String weekDay;

      switch (weekdayFormat) {
        case WeekdayFormat.weekdays:
          weekDay = localeDate.dateSymbols.WEEKDAYS[i];
        case WeekdayFormat.standalone:
          weekDay = localeDate.dateSymbols.STANDALONEWEEKDAYS[i];
        case WeekdayFormat.short:
          weekDay = localeDate.dateSymbols.SHORTWEEKDAYS[i];
        case WeekdayFormat.standaloneShort:
          weekDay = localeDate.dateSymbols.STANDALONESHORTWEEKDAYS[i];
        case WeekdayFormat.narrow:
          weekDay = localeDate.dateSymbols.NARROWWEEKDAYS[i];
        case WeekdayFormat.standaloneNarrow:
          weekDay = localeDate.dateSymbols.STANDALONENARROWWEEKDAYS[i];
      }
      list.add(_weekdayContainer(count, weekDay));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) => showWeekdays
      ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _renderWeekDays(),
        )
      : Container();
}
