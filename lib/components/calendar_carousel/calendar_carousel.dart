

// ignore_for_file: avoid_positional_boolean_parameters, library_private_types_in_public_api, lines_longer_than_80_chars, prefer_if_null_operators, avoid_dynamic_calls, sized_box_shrink_expand, prefer_conditional_assignment

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habit_quest/components/calendar_carousel/classes.dart';
import 'package:habit_quest/components/calendar_carousel/src.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;



typedef MarkedDateIconBuilder<T> = Widget? Function(T event);
typedef OnDayLongPressed = void Function(DateTime day);


typedef DayBuilder = Widget? Function(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle textStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
    DateTime day,);


typedef WeekdayBuilder = Widget Function(int weekday, String weekdayName);

class CalendarCarousel<T extends EventInterface> extends StatefulWidget {

  const CalendarCarousel({
    super.key,
    this.viewportFraction = 1.0,
    this.prevDaysTextStyle,
    this.daysTextStyle,
    this.nextDaysTextStyle,
    this.prevMonthDayBorderColor = Colors.transparent,
    this.thisMonthDayBorderColor = Colors.transparent,
    this.nextMonthDayBorderColor = Colors.transparent,
    this.dayPadding = 2.0,
    this.height = double.infinity,
    this.width = double.infinity,
    this.todayTextStyle,
    this.dayButtonColor = Colors.transparent,
    this.todayBorderColor = Colors.red,
    this.todayButtonColor = Colors.red,
    this.selectedDateTime,
    this.targetDateTime,
    this.selectedDayTextStyle,
    this.selectedDayBorderColor = Colors.green,
    this.selectedDayButtonColor = Colors.green,
    this.daysHaveCircularBorder,
    this.disableDayPressed = false,
    this.onDayPressed,
    this.weekdayTextStyle = const TextStyle(),
    this.iconColor = Colors.blueAccent,
    this.headerTextStyle,
    this.headerText,
    this.weekendTextStyle,
    this.markedDatesMap,
    this.markedDateShowIcon = false,
    this.markedDateIconBorderColor,
    this.markedDateIconMaxShown = 2,
    this.markedDateIconMargin = 5.0,
    this.markedDateIconOffset = 5.0,
    this.markedDateIconBuilder,
    this.markedDateMoreShowTotal,
    this.markedDateMoreCustomDecoration,
    this.markedDateCustomShapeBorder,
    this.markedDateCustomTextStyle,
    this.markedDateMoreCustomTextStyle,
    this.markedDateWidget,
    this.multipleMarkedDates,
    this.headerMargin = const EdgeInsets.symmetric(vertical: 16),
    this.childAspectRatio = 1.0,
    this.weekDayMargin = const EdgeInsets.only(bottom: 4),
    this.weekDayPadding = EdgeInsets.zero,
    this.weekDayBackgroundColor = Colors.transparent,
    this.customWeekDayBuilder,
    this.customDayBuilder,
    this.showWeekDays = true,
    this.weekFormat = false,
    this.showHeader = true,
    this.showHeaderButton = true,
    this.leftButtonIcon,
    this.rightButtonIcon,
    this.customGridViewPhysics,
    this.onCalendarChanged,
    this.locale = 'en',
    this.firstDayOfWeek,
    this.minSelectedDate,
    this.maxSelectedDate,
    this.inactiveDaysTextStyle,
    this.inactiveWeekendTextStyle,
    this.headerTitleTouchable = false,
    this.onHeaderTitlePressed,
    this.onLeftArrowPressed,
    this.onRightArrowPressed,
    this.weekDayFormat = WeekdayFormat.short,
    this.staticSixWeekFormat = false,
    this.isScrollable = true,
    this.scrollDirection = Axis.horizontal,
    this.showOnlyCurrentMonthDate = false,
    this.pageSnapping = false,
    this.onDayLongPressed,
    this.dayCrossAxisAlignment = CrossAxisAlignment.center,
    this.dayMainAxisAlignment = MainAxisAlignment.center,
    this.showIconBehindDayText = false,
    this.pageScrollPhysics = const ScrollPhysics(),
    this.shouldShowTransform = true,
    this.maxDot = 5,
  });
  final double viewportFraction;
  final TextStyle? prevDaysTextStyle;
  final TextStyle? daysTextStyle;
  final TextStyle? nextDaysTextStyle;
  final Color prevMonthDayBorderColor;
  final Color thisMonthDayBorderColor;
  final Color nextMonthDayBorderColor;
  final double dayPadding;
  final double height;
  final double width;
  final TextStyle? todayTextStyle;
  final Color dayButtonColor;
  final Color todayBorderColor;
  final Color todayButtonColor;
  final DateTime? selectedDateTime;
  final DateTime? targetDateTime;
  final TextStyle? selectedDayTextStyle;
  final Color selectedDayButtonColor;
  final Color selectedDayBorderColor;
  final bool? daysHaveCircularBorder;
  final bool disableDayPressed;
  final Function Function(DateTime, List<T>)? onDayPressed;
  final TextStyle? weekdayTextStyle;
  final Color iconColor;
  final TextStyle? headerTextStyle;
  final String? headerText;
  final TextStyle? weekendTextStyle;
  final EventList<T>? markedDatesMap;


  final Widget? markedDateWidget;

  final OutlinedBorder? markedDateCustomShapeBorder;

  final TextStyle? markedDateCustomTextStyle;


  final bool markedDateShowIcon;
  final Color? markedDateIconBorderColor;
  final int markedDateIconMaxShown;
  final double markedDateIconMargin;
  final double markedDateIconOffset;
  final MarkedDateIconBuilder<T>? markedDateIconBuilder;

  final bool? markedDateMoreShowTotal;
  final Decoration? markedDateMoreCustomDecoration;
  final TextStyle? markedDateMoreCustomTextStyle;
  final EdgeInsets headerMargin;
  final double childAspectRatio;
  final EdgeInsets weekDayMargin;
  final EdgeInsets weekDayPadding;
  final WeekdayBuilder? customWeekDayBuilder;
  final DayBuilder? customDayBuilder;
  final Color weekDayBackgroundColor;
  final bool weekFormat;
  final bool showWeekDays;
  final bool showHeader;
  final bool showHeaderButton;
  final MultipleMarkedDates? multipleMarkedDates;
  final Widget? leftButtonIcon;
  final Widget? rightButtonIcon;
  final ScrollPhysics? customGridViewPhysics;
  final Function Function(DateTime)? onCalendarChanged;
  final String locale;
  final int? firstDayOfWeek;
  final DateTime? minSelectedDate;
  final DateTime? maxSelectedDate;
  final TextStyle? inactiveDaysTextStyle;
  final TextStyle? inactiveWeekendTextStyle;
  final bool headerTitleTouchable;
  final Function? onHeaderTitlePressed;
  final Function? onLeftArrowPressed;
  final Function? onRightArrowPressed;
  final WeekdayFormat weekDayFormat;
  final bool staticSixWeekFormat;
  final bool isScrollable;
  final Axis scrollDirection;
  final bool showOnlyCurrentMonthDate;
  final bool pageSnapping;
  final OnDayLongPressed? onDayLongPressed;
  final CrossAxisAlignment dayCrossAxisAlignment;
  final MainAxisAlignment dayMainAxisAlignment;
  final bool showIconBehindDayText;
  final ScrollPhysics pageScrollPhysics;
  final bool shouldShowTransform;

  ///Maximium number of dots to be shown
  final int maxDot ;

  @override
  _CalendarState<T> createState() => _CalendarState<T>();
}

enum WeekdayFormat {
  weekdays,
  standalone,
  short,
  standaloneShort,
  narrow,
  standaloneNarrow,
}

class _CalendarState<T extends EventInterface>
    extends State<CalendarCarousel<T>> {
  late PageController _controller;
  late List<DateTime> _dates;
  late List<List<DateTime>> _weeks;
  DateTime _selectedDate = DateTime.now();
  late DateTime _targetDate;
  int _startWeekday = 0;
  int _endWeekday = 0;
  late DateFormat _localeDate;
  int _pageNum = 0;
  late DateTime minDate;
  late DateTime maxDate;


  late int firstDayOfWeek;


  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    minDate = widget.minSelectedDate ?? DateTime(2018);
    maxDate = widget.maxSelectedDate ??
        DateTime(
            DateTime.now().year + 1, DateTime.now().month, DateTime.now().day,);

    final selectedDateTime = widget.selectedDateTime;
    if (selectedDateTime != null) _selectedDate = selectedDateTime;

    _init();

    /// setup pageController
    _controller = PageController(
      initialPage: this._pageNum,
      viewportFraction: widget.viewportFraction,

      /// width percentage
    );

    _localeDate = DateFormat.yMMM(widget.locale);
    firstDayOfWeek = widget.firstDayOfWeek ??
        (_localeDate.dateSymbols.FIRSTDAYOFWEEK + 1) % 7;

    _setDate();
  }

  @override
  void didUpdateWidget(CalendarCarousel<T> oldWidget) {
    if (widget.targetDateTime != null && widget.targetDateTime != _targetDate) {
      _init();
      _setDate(_pageNum);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
 void dispose() {
    _controller.dispose();
    super.dispose();
  }

void  _init() {
    final targetDateTime = widget.targetDateTime;
    if (targetDateTime != null) {
      if (targetDateTime.difference(minDate).inDays < 0) {
        _targetDate = minDate;
      } else if (targetDateTime.difference(maxDate).inDays > 0) {
        _targetDate = maxDate;
      } else {
        _targetDate = targetDateTime;
      }
    } else {
      _targetDate = _selectedDate;
    }
    if (widget.weekFormat) {
      _pageNum = _targetDate.difference(_firstDayOfWeek(minDate)).inDays ~/ 7;
    } else {
      _pageNum = (_targetDate.year - minDate.year) * 12 +
          _targetDate.month -
          minDate.month;
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerText = widget.headerText;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: <Widget>[
          CalendarHeader(
            showHeader: widget.showHeader,
            headerMargin: widget.headerMargin,
            headerTitle: headerText != null
                ? headerText
                : widget.weekFormat
                    ? _localeDate.format(this._weeks[this._pageNum].first)
                    : _localeDate.format(this._dates[this._pageNum]),
            headerTextStyle: widget.headerTextStyle,
            showHeaderButtons: widget.showHeaderButton,
            headerIconColor: widget.iconColor,
            leftButtonIcon: widget.leftButtonIcon,
            rightButtonIcon: widget.rightButtonIcon,
            onLeftButtonPressed: () {
              widget.onLeftArrowPressed?.call();

              if (this._pageNum > 0) _setDate(this._pageNum - 1);
            },
            onRightButtonPressed: () {
              widget.onRightArrowPressed?.call();

              if (widget.weekFormat) {
                if (this._weeks.length - 1 > this._pageNum) {
                  _setDate(this._pageNum + 1);
                }
              } else {
                if (this._dates.length - 1 > this._pageNum) {
                  _setDate(this._pageNum + 1);
                }
              }
            },
            onHeaderTitlePressed: widget.headerTitleTouchable
                ? () {
                    final onHeaderTitlePressed = widget.onHeaderTitlePressed;
                    if (onHeaderTitlePressed != null) {
                      onHeaderTitlePressed();
                    } else {
                      _selectDateFromPicker();
                    }
                  }
                : null,
          ),
          WeekdayRow(
            firstDayOfWeek,
            widget.customWeekDayBuilder,
            showWeekdays: widget.showWeekDays,
            weekdayFormat: widget.weekDayFormat,
            weekdayMargin: widget.weekDayMargin,
            weekdayPadding: widget.weekDayPadding,
            weekdayBackgroundColor: widget.weekDayBackgroundColor,
            weekdayTextStyle: widget.weekdayTextStyle,
            localeDate: _localeDate,
          ),
          Expanded(
              child: PageView.builder(
            itemCount:
                widget.weekFormat ? this._weeks.length : this._dates.length,
            physics: widget.isScrollable
                ? widget.pageScrollPhysics
                : const NeverScrollableScrollPhysics(),
            scrollDirection: widget.scrollDirection,
            onPageChanged: (index) {
              this._setDate(index);
            },
            controller: _controller,
            itemBuilder: (context, index) {
              return widget.weekFormat ? weekBuilder(index) : builder(index);
            },
            pageSnapping: widget.pageSnapping,
          ),),
        ],
      ),
    );
  }

  Widget getDefaultDayContainer(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle? textStyle,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
    DateTime now,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        crossAxisAlignment: widget.dayCrossAxisAlignment,
        mainAxisAlignment: widget.dayMainAxisAlignment,
        children: <Widget>[
          DefaultTextStyle(
            style: getDefaultDayStyle(
                isSelectable,
                index,
                isSelectedDay,
                isToday,
                isPrevMonthDay,
                textStyle,
                defaultTextStyle,
                isNextMonthDay,
                isThisMonthDay,),
            child: Text(
              '${now.day}',
              semanticsLabel: now.day.toString(),
              style: getDayStyle(
                  isSelectable,
                  index,
                  isSelectedDay,
                  isToday,
                  isPrevMonthDay,
                  textStyle,
                  defaultTextStyle,
                  isNextMonthDay,
                  isThisMonthDay,
                  now,),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget renderDay(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle? textStyle,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
    DateTime now,
  ) {
    // If day is in Multiple selection mode, get its color
    final isMultipleMarked = widget.multipleMarkedDates?.isMarked(now) ?? false;
    final multipleMarkedColor = widget.multipleMarkedDates?.getColor(now);

    final markedDatesMap = widget.markedDatesMap;
    return Container(
      margin: EdgeInsets.all(widget.dayPadding),
      child: GestureDetector(
        onLongPress: () => _onDayLongPressed(now),
        child: TextButton(
          style: TextButton.styleFrom(
            shape: widget.markedDateCustomShapeBorder != null &&
                    markedDatesMap != null &&
                    markedDatesMap.getEvents(now).isNotEmpty
                ? widget.markedDateCustomShapeBorder
                : widget.daysHaveCircularBorder == null
                    ? const CircleBorder()
                    : widget.daysHaveCircularBorder ?? false
                        ? CircleBorder(
                            side: BorderSide(
                              color: isSelectedDay
                                  ? widget.selectedDayBorderColor
                                  : isToday
                                      ? widget.todayBorderColor
                                      : isPrevMonthDay
                                          ? widget.prevMonthDayBorderColor
                                          : isNextMonthDay
                                              ? widget.nextMonthDayBorderColor
                                              : widget.thisMonthDayBorderColor,
                            ),
                          )
                        : RoundedRectangleBorder(
                            side: BorderSide(
                              color: isSelectedDay
                                  ? widget.selectedDayBorderColor
                                  : isToday
                                      ? widget.todayBorderColor
                                      : isPrevMonthDay
                                          ? widget.prevMonthDayBorderColor
                                          : isNextMonthDay
                                              ? widget.nextMonthDayBorderColor
                                              : widget.thisMonthDayBorderColor,
                            ),
                          ),
            backgroundColor: isSelectedDay
                ? widget.selectedDayButtonColor
                : isToday
                    ? widget.todayButtonColor

                    // If day is in Multiple selection mode, apply a different color
                    : isMultipleMarked
                        ? multipleMarkedColor
                        : widget.dayButtonColor,
            padding: EdgeInsets.all(widget.dayPadding),
          ),
          onPressed: widget.disableDayPressed ? null : () => _onDayPressed(now),
          child: Stack(
            children: widget.showIconBehindDayText
                ? <Widget>[
                    if (widget.markedDatesMap != null) _renderMarkedMapContainer(now) else Container(),
                    getDayContainer(
                        isSelectable,
                        index,
                        isSelectedDay,
                        isToday,
                        isPrevMonthDay,
                        textStyle,
                        defaultTextStyle,
                        isNextMonthDay,
                        isThisMonthDay,
                        now,),
                  ]
                : <Widget>[
                    getDayContainer(
                        isSelectable,
                        index,
                        isSelectedDay,
                        isToday,
                        isPrevMonthDay,
                        textStyle,
                        defaultTextStyle,
                        isNextMonthDay,
                        isThisMonthDay,
                        now,),
                    if (widget.markedDatesMap != null) _renderMarkedMapContainer(now) else Container(),
                  ],
          ),
        ),
      ),
    );
  }

  AnimatedBuilder builder(int slideIndex) {
    _startWeekday = _dates[slideIndex].weekday - firstDayOfWeek;
    if (_startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday =
        DateTime(_dates[slideIndex].year, _dates[slideIndex].month + 1)
                .weekday -
            firstDayOfWeek;
    final screenWidth = MediaQuery.of(context).size.width;
    final totalItemCount = widget.staticSixWeekFormat
        ? 42
        : DateTime(
              _dates[slideIndex].year,
              _dates[slideIndex].month + 1,
              0,
            ).day +
            _startWeekday +
            (7 - _endWeekday);
    final year = _dates[slideIndex].year;
    final month = _dates[slideIndex].month;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        if (!widget.shouldShowTransform) {
          return child!;
        }
        var value = 1.0;
        if (_controller.position.haveDimensions) {
          value = _controller.page! - slideIndex;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * widget.height,
            width: Curves.easeOut.transform(value) * screenWidth,
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Positioned(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: GridView.count(
                physics: widget.customGridViewPhysics,
                crossAxisCount: 7,
                childAspectRatio: widget.childAspectRatio,
                padding: EdgeInsets.zero,
                children: List.generate(totalItemCount,

                    /// last day of month + weekday
                    (index) {
                  final selectedDateTime = widget.selectedDateTime;
                  final isToday =
                      DateTime.now().day == index + 1 - _startWeekday &&
                          DateTime.now().month == month &&
                          DateTime.now().year == year;
                  final isSelectedDay = selectedDateTime != null &&
                      selectedDateTime.year == year &&
                      selectedDateTime.month == month &&
                      selectedDateTime.day == index + 1 - _startWeekday;
                  final isPrevMonthDay = index < _startWeekday;
                  final isNextMonthDay = index >=
                      (DateTime(year, month + 1, 0).day) + _startWeekday;
                  final isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                  var now = DateTime(year, month);
                  TextStyle? textStyle;
                  TextStyle defaultTextStyle;
                  if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
                    now = now.subtract(Duration(days: _startWeekday - index));
                    textStyle = widget.prevDaysTextStyle;
                    defaultTextStyle = defaultPrevDaysTextStyle;
                  } else if (isThisMonthDay) {
                    now = DateTime(year, month, index + 1 - _startWeekday);
                    textStyle = isSelectedDay
                        ? widget.selectedDayTextStyle
                        : isToday
                            ? widget.todayTextStyle
                            : widget.daysTextStyle;
                    defaultTextStyle = isSelectedDay
                        ? defaultSelectedDayTextStyle
                        : isToday
                            ? defaultTodayTextStyle
                            : defaultDaysTextStyle;
                  } else if (!widget.showOnlyCurrentMonthDate) {
                    now = DateTime(year, month, index + 1 - _startWeekday);
                    textStyle = widget.nextDaysTextStyle;
                    defaultTextStyle = defaultNextDaysTextStyle;
                  } else {
                    return Container();
                  }
                  final markedDatesMap = widget.markedDatesMap;
                  if (widget.markedDateCustomTextStyle != null &&
                      markedDatesMap != null &&
                      markedDatesMap.getEvents(now).isNotEmpty) {
                    textStyle = widget.markedDateCustomTextStyle;
                  }
                  var isSelectable = true;
                  if (now.millisecondsSinceEpoch <
                      minDate.millisecondsSinceEpoch) {
                    isSelectable = false;
                  } else if (now.millisecondsSinceEpoch >
                      maxDate.millisecondsSinceEpoch) {
                        isSelectable = false;
                      }
                  return renderDay(
                      isSelectable,
                      index,
                      isSelectedDay,
                      isToday,
                      isPrevMonthDay,
                      textStyle,
                      defaultTextStyle,
                      isNextMonthDay,
                      isThisMonthDay,
                      now,);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AnimatedBuilder weekBuilder(int slideIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    var weekDays = _weeks[slideIndex];

    weekDays = weekDays
        .map((weekDay) => weekDay.add(Duration(days: firstDayOfWeek)))
        .toList();

    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          var value = 1.0;
          if (_controller.position.haveDimensions) {
            value = _controller.page! - slideIndex;
            value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
          }

          return Center(
            child: SizedBox(
              height: Curves.easeOut.transform(value) * widget.height,
              width: Curves.easeOut.transform(value) * screenWidth,
              child: child,
            ),
          );
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: GridView.count(
                  physics: widget.customGridViewPhysics,
                  crossAxisCount: 7,
                  childAspectRatio: widget.childAspectRatio,
                  padding: EdgeInsets.zero,
                  children: List.generate(weekDays.length, (index) {
                    /// last day of month + weekday
                    final isToday = weekDays[index].day == DateTime.now().day &&
                        weekDays[index].month == DateTime.now().month &&
                        weekDays[index].year == DateTime.now().year;
                    final isSelectedDay =
                        this._selectedDate.year == weekDays[index].year &&
                            this._selectedDate.month == weekDays[index].month &&
                            this._selectedDate.day == weekDays[index].day;
                    final isPrevMonthDay =
                        weekDays[index].month < this._targetDate.month;
                    final isNextMonthDay =
                        weekDays[index].month > this._targetDate.month;
                    final isThisMonthDay = !isPrevMonthDay && !isNextMonthDay;

                    final now = DateTime(weekDays[index].year,
                        weekDays[index].month, weekDays[index].day,);
                    TextStyle? textStyle;
                    TextStyle defaultTextStyle;
                    if (isPrevMonthDay && !widget.showOnlyCurrentMonthDate) {
                      textStyle = widget.prevDaysTextStyle;
                      defaultTextStyle = defaultPrevDaysTextStyle;
                    } else if (isThisMonthDay) {
                      textStyle = isSelectedDay
                          ? widget.selectedDayTextStyle
                          : isToday
                              ? widget.todayTextStyle
                              : widget.daysTextStyle;
                      defaultTextStyle = isSelectedDay
                          ? defaultSelectedDayTextStyle
                          : isToday
                              ? defaultTodayTextStyle
                              : defaultDaysTextStyle;
                    } else if (!widget.showOnlyCurrentMonthDate) {
                      textStyle = widget.nextDaysTextStyle;
                      defaultTextStyle = defaultNextDaysTextStyle;
                    } else {
                      return Container();
                    }
                    var isSelectable = true;
                    if (now.millisecondsSinceEpoch <
                        minDate.millisecondsSinceEpoch) {
                      isSelectable = false;
                    } else if (now.millisecondsSinceEpoch >
                        maxDate.millisecondsSinceEpoch) {
                           isSelectable = false;
                        }
                    return renderDay(
                        isSelectable,
                        index,
                        isSelectedDay,
                        isToday,
                        isPrevMonthDay,
                        textStyle,
                        defaultTextStyle,
                        isNextMonthDay,
                        isThisMonthDay,
                        now,);
                  }),
                ),
              ),
            ),
          ],
        ),);
  }

  List<DateTime> _getDaysInWeek([DateTime? selectedDate]) {
    if (selectedDate == null) selectedDate = DateTime.now();

    final firstDayOfCurrentWeek = _firstDayOfWeek(selectedDate);
    final lastDayOfCurrentWeek = _lastDayOfWeek(selectedDate);

    return _daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
  }

  DateTime _firstDayOfWeek(DateTime date) {
    final day = _createUTCMiddayDateTime(date);
    return day.subtract(Duration(days: date.weekday % 7));
  }

  DateTime _lastDayOfWeek(DateTime date) {
    final day = _createUTCMiddayDateTime(date);
    return day.add(Duration(days: 7 - day.weekday % 7));
  }

  DateTime _createUTCMiddayDateTime(DateTime date) {
    // Magic const: 12 is to maintain compatibility with date_utils
    return DateTime.utc(date.year, date.month, date.day, 12);
  }

  Iterable<DateTime> _daysInRange(DateTime start, DateTime end) {
    var offset = start.timeZoneOffset;

    return List<int>.generate(end.difference(start).inDays, (i) => i + 1)
        .map((int i) {
      var d = start.add(Duration(days: i - 1));

      final timeZoneDiff = d.timeZoneOffset - offset;
      if (timeZoneDiff.inSeconds != 0) {
        offset = d.timeZoneOffset;
        d = d.subtract(Duration(seconds: timeZoneDiff.inSeconds));
      }
      return d;
    });
  }

  void _onDayLongPressed(DateTime picked) {
    widget.onDayLongPressed?.call(picked);
  }

  void _onDayPressed(DateTime picked) {
    if (picked.millisecondsSinceEpoch < minDate.millisecondsSinceEpoch) return;
    if (picked.millisecondsSinceEpoch > maxDate.millisecondsSinceEpoch) return;

    setState(() {
      _selectedDate = picked;
    });
    widget.onDayPressed
        ?.call(picked, widget.markedDatesMap?.getEvents(picked) ?? const []);
  }

  Future<Null> _selectDateFromPicker() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (selected != null) {
      // updating selected date range based on selected week
      setState(() {
        _selectedDate = selected;
      });
      widget.onDayPressed?.call(
          selected, widget.markedDatesMap?.getEvents(selected) ?? const [],);
    }
  }

  void _setDatesAndWeeks() {
    /// Setup default calendar format
    final date = <DateTime>[];
    var currentDateIndex = 0;
    for (var cnt = 0;
        0 >=
            DateTime(minDate.year, minDate.month + cnt)
                .difference(DateTime(maxDate.year, maxDate.month))
                .inDays;
        cnt++) {
      date.add(DateTime(minDate.year, minDate.month + cnt));
      if (0 ==
          date.last
              .difference(
                  DateTime(this._targetDate.year, this._targetDate.month),)
              .inDays) {
        currentDateIndex = cnt;
      }
    }

    /// Setup week-only format
    final week = <List<DateTime>>[];
    for (var cnt0 = 0;
        0 >=
            minDate
                .add(Duration(days: 7 * cnt0))
                .difference(maxDate.add(const Duration(days: 7)))
                .inDays;
        cnt0++) {
      week.add(_getDaysInWeek(minDate.add(Duration(days: 7 * cnt0))));
    }

    _startWeekday = date[currentDateIndex].weekday - firstDayOfWeek;
    /*if (widget.showOnlyCurrentMonthDate) {
      _startWeekday--;
    }*/
    if (/*widget.showOnlyCurrentMonthDate && */ _startWeekday == 7) {
      _startWeekday = 0;
    }
    _endWeekday = DateTime(date[currentDateIndex].year,
                date[currentDateIndex].month + 1,)
            .weekday -
        firstDayOfWeek;
    this._dates = date;
    this._weeks = week;
  }

  void _setDate([int page = -1]) {
    if (page == -1) {
      setState(_setDatesAndWeeks);
    } else {
      if (widget.weekFormat) {
        setState(() {
          this._pageNum = page;
          this._targetDate = this._weeks[page].first;
        });

        _controller.animateToPage(page,
            duration: const Duration(milliseconds: 1), curve: const Threshold(0),);
      } else {
        setState(() {
          this._pageNum = page;
          this._targetDate = this._dates[page];
          _startWeekday = _dates[page].weekday - firstDayOfWeek;
          _endWeekday = _lastDayOfWeek(_dates[page]).weekday - firstDayOfWeek;
        });
        _controller.animateToPage(page,
            duration: const Duration(milliseconds: 1), curve: const Threshold(0),);
      }

      //call callback
      final onCalendarChanged = widget.onCalendarChanged;
      if (onCalendarChanged != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onCalendarChanged(!widget.weekFormat
              ? this._dates[page]
              : this._weeks[page][firstDayOfWeek],);
        });
      }
    }
  }

  Widget _renderMarkedMapContainer(DateTime now) {
    if (widget.markedDateShowIcon) {
      return Stack(
        children: _renderMarkedMap(now),
      );
    } else {
      return Container(
        height: double.infinity,
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: _renderMarkedMap(now),
        ),
      );
    }
  }

  List<Widget> _renderMarkedMap(DateTime now) {
    final markedEvents = widget.markedDatesMap?.getEvents(now) ?? [];
    final markedDateIconBuilder = widget.markedDateIconBuilder;
    final markedDateWidget = widget.markedDateWidget;
    final markedDateMoreShowTotal = widget.markedDateMoreShowTotal;
    final markedDateMoreCustomTextStyle = widget.markedDateMoreCustomTextStyle;
    final markedDateIconMargin = widget.markedDateIconMargin;
    final markedDateShowIcon = widget.markedDateShowIcon;
    final markedDateIconMaxShown = widget.markedDateIconMaxShown;
    final markedDateIconOffset = widget.markedDateIconOffset;
    final markedDateMoreCustomDecoration =
        widget.markedDateMoreCustomDecoration;

    if (markedEvents.isNotEmpty) {
      final tmp = <Widget>[];
      var count = 0;
      var eventIndex = 0;
      var offset = 0.0;
      final padding = markedDateIconMargin;
      for (final event in markedEvents) {
        if (markedDateShowIcon) {
          if (tmp.isNotEmpty && tmp.length < markedDateIconMaxShown) {
            offset += markedDateIconOffset;
          }
          if (tmp.length < markedDateIconMaxShown &&
              markedDateIconBuilder != null) {
            tmp.add(Center(
                child: Container(
              padding: EdgeInsets.only(
                top: padding + offset,
                left: padding + offset,
                right: padding - offset,
                bottom: padding - offset,
              ),
              width: double.infinity,
              height: double.infinity,
              child: markedDateIconBuilder(event),
            ),),);
          } else {
            count++;
          }
          if (count > 0 && markedDateMoreShowTotal != null) {
            tmp.add(
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  width: markedDateMoreShowTotal ? 18 : null,
                  height: markedDateMoreShowTotal ? 18 : null,
                  decoration: markedDateMoreCustomDecoration == null
                      ? const BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.all(Radius.circular(1000)),
                        )
                      : markedDateMoreCustomDecoration,
                  child: Center(
                    child: Text(
                      markedDateMoreShowTotal
                          ? (count + markedDateIconMaxShown).toString()
                          : ('$count+'),
                      semanticsLabel: markedDateMoreShowTotal
                          ? (count + markedDateIconMaxShown).toString()
                          : ('$count+'),
                      style: markedDateMoreCustomTextStyle == null
                          ? const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,)
                          : markedDateMoreCustomTextStyle,
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          //max 5 dots
          if (eventIndex < widget.maxDot) {
            Widget? widget;

            if (markedDateIconBuilder != null) {
              widget = markedDateIconBuilder(event);
            }

            if (widget != null) {
              tmp.add(widget);
            } else {
              final dot = event.getDot();
              if (dot != null) {
                tmp.add(dot);
              } else if (markedDateWidget != null) {
                tmp.add(markedDateWidget);
              } else {
                tmp.add(defaultMarkedDateWidget);
              }
            }
          }
        }

        eventIndex++;
      }
      return tmp;
    }
    return [];
  }

  TextStyle getDefaultDayStyle(
    bool isSelectable,
    int index,
    bool isSelectedDay,
    bool isToday,
    bool isPrevMonthDay,
    TextStyle? textStyle,
    TextStyle defaultTextStyle,
    bool isNextMonthDay,
    bool isThisMonthDay,
  ) {
    return !isSelectable
        ? defaultInactiveDaysTextStyle
        : (_localeDate.dateSymbols.WEEKENDRANGE
                    .contains((index - 1 + firstDayOfWeek) % 7)) &&
                !isSelectedDay &&
                !isToday
            ? (isPrevMonthDay
                ? defaultPrevDaysTextStyle
                : isNextMonthDay
                    ? defaultNextDaysTextStyle
                    : isSelectable
                        ? defaultWeekendTextStyle
                        : defaultInactiveWeekendTextStyle)
            : isToday
                ? defaultTodayTextStyle
                : isSelectable && textStyle != null
                    ? textStyle
                    : defaultTextStyle;
  }

  TextStyle? getDayStyle(
      bool isSelectable,
      int index,
      bool isSelectedDay,
      bool isToday,
      bool isPrevMonthDay,
      TextStyle? textStyle,
      TextStyle defaultTextStyle,
      bool isNextMonthDay,
      bool isThisMonthDay,
      DateTime now,) {
    // If day is in multiple selection get its style(if available)
    final isMultipleMarked = widget.multipleMarkedDates?.isMarked(now) ?? false;
    final mutipleMarkedTextStyle =
        widget.multipleMarkedDates?.getTextStyle(now);

    return isSelectedDay && widget.selectedDayTextStyle != null
        ? widget.selectedDayTextStyle
        : isMultipleMarked
            ? mutipleMarkedTextStyle
            : (_localeDate.dateSymbols.WEEKENDRANGE
                        .contains((index - 1 + firstDayOfWeek) % 7)) &&
                    !isSelectedDay &&
                    isThisMonthDay &&
                    !isToday
                ? (isSelectable
                    ? widget.weekendTextStyle
                    : widget.inactiveWeekendTextStyle)
                : !isSelectable
                    ? widget.inactiveDaysTextStyle
                    : isPrevMonthDay
                        ? widget.prevDaysTextStyle
                        : isNextMonthDay
                            ? widget.nextDaysTextStyle
                            : isToday
                                ? widget.todayTextStyle
                                : widget.daysTextStyle;
  }

  Widget getDayContainer(
      bool isSelectable,
      int index,
      bool isSelectedDay,
      bool isToday,
      bool isPrevMonthDay,
      TextStyle? textStyle,
      TextStyle defaultTextStyle,
      bool isNextMonthDay,
      bool isThisMonthDay,
      DateTime now,) {
    final customDayBuilder = widget.customDayBuilder;

    Widget? dayContainer;
    if (customDayBuilder != null) {
      final appTextStyle = DefaultTextStyle.of(context).style;

      final dayStyle = getDayStyle(
        isSelectable,
        index,
        isSelectedDay,
        isToday,
        isPrevMonthDay,
        textStyle,
        defaultTextStyle,
        isNextMonthDay,
        isThisMonthDay,
        now,
      );

      final styleForBuilder = appTextStyle.merge(dayStyle);

      dayContainer = customDayBuilder(
          isSelectable,
          index,
          isSelectedDay,
          isToday,
          isPrevMonthDay,
          styleForBuilder,
          isNextMonthDay,
          isThisMonthDay,
          now,);
    }

    return dayContainer ??
        getDefaultDayContainer(
          isSelectable,
          index,
          isSelectedDay,
          isToday,
          isPrevMonthDay,
          textStyle,
          defaultTextStyle,
          isNextMonthDay,
          isThisMonthDay,
          now,
        );
  }
}
