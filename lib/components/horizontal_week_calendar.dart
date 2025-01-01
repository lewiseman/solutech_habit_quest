import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:habit_quest/config/config.dart';
import 'package:intl/intl.dart';

enum WeekStartFrom {
  sunday,
  monday,
}

class HorizontalWeekCalendar extends StatefulWidget {
  HorizontalWeekCalendar({
    required this.minDate,
    required this.maxDate,
    required this.selectedDate,
    super.key,
    this.onDateChange,
    this.onWeekChange,
    this.activeNavigatorColor,
    this.inactiveNavigatorColor,
    this.monthColor,
    this.weekStartFrom = WeekStartFrom.monday,
    this.showNavigationButtons = true,
    this.monthFormat,
    this.showTopNavbar = true,
  })  : assert(minDate.isBefore(maxDate)),
        super();
  final WeekStartFrom? weekStartFrom;
  final void Function(DateTime)? onDateChange;
  final void Function(List<DateTime>)? onWeekChange;

  /// Active Navigator color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor
  /// ```
  final Color? activeNavigatorColor;
  final Color? inactiveNavigatorColor;
  final Color? monthColor;


  /// showNavigationButtons
  ///
  /// Default value is `true`
  final bool? showNavigationButtons;

  /// monthFormat
  ///
  /// If it's current year then
  /// Default value will be ```MMMM```
  ///
  /// Otherwise
  /// Default value will be `MMMM yyyy`
  final String? monthFormat;

  final DateTime minDate;

  final DateTime maxDate;

  final DateTime selectedDate;

  final bool showTopNavbar;

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  CarouselSliderController carouselController = CarouselSliderController();

  final int _initialPage = 1;

  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<DateTime> currentWeek = [];
  int currentWeekIndex = 0;

  List<List<DateTime>> listOfWeeks = [];

  @override
  void initState() {
    initCalender();
    super.initState();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  initCalender() {
    final date = widget.selectedDate;
    selectedDate = widget.selectedDate;

    final startOfCurrentWeek = widget.weekStartFrom == WeekStartFrom.monday
        ? getDate(date.subtract(Duration(days: date.weekday - 1)))
        : getDate(date.subtract(Duration(days: date.weekday % 7)));

    currentWeek.add(startOfCurrentWeek);
    for (var index = 0; index < 6; index++) {
      final addDate = startOfCurrentWeek.add(Duration(days: index + 1));
      currentWeek.add(addDate);
    }

    listOfWeeks.add(currentWeek);

    _getMorePreviousWeeks();

    _getMoreNextWeeks();
  }

  _getMorePreviousWeeks() {
    final minus7Days = <DateTime>[];
    final startFrom = listOfWeeks[currentWeekIndex].first;

    var canAdd = false;
    for (var index = 0; index < 7; index++) {
      final minusDate = startFrom.add(Duration(days: -(index + 1)));
      minus7Days.add(minusDate);
      // if (widget.minDate != null) {
      if (minusDate.add(const Duration(days: 1)).isAfter(widget.minDate)) {
        canAdd = true;
      }
      // } else {
      //   canAdd = true;
      // }
    }
    if (canAdd == true) {
      listOfWeeks.add(minus7Days.reversed.toList());
    }
    setState(() {});
  }

  _getMoreNextWeeks() {
    final plus7Days = <DateTime>[];
    // DateTime startFrom = currentWeek.last;
    final startFrom = listOfWeeks[currentWeekIndex].last;

    // bool canAdd = false;
    // int newCurrentWeekIndex = 1;
    for (var index = 0; index < 7; index++) {
      final addDate = startFrom.add(Duration(days: index + 1));
      plus7Days.add(addDate);
      // if (widget.maxDate != null) {
      //   if (addDate.isBefore(widget.maxDate!)) {
      //     canAdd = true;
      //     newCurrentWeekIndex = 1;
      //   } else {
      //     newCurrentWeekIndex = 0;
      //   }
      // } else {
      //   canAdd = true;
      //   newCurrentWeekIndex = 1;
      // }
    }
    // print("canAdd: $canAdd");
    // print("newCurrentWeekIndex: $newCurrentWeekIndex");

    // if (canAdd == true) {
    listOfWeeks.insert(0, plus7Days);
    // }
    currentWeekIndex = 1;
    setState(() {});
  }

  _onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateChange?.call(selectedDate);
  }

  _onBackClick() {
    carouselController.nextPage();
  }

  _onNextClick() {
    carouselController.previousPage();
  }

  onWeekChange(int index) {
    if (currentWeekIndex < index) {
      // on back
    }
    if (currentWeekIndex > index) {
      // on next
    }

    currentWeekIndex = index;
    currentWeek = listOfWeeks[currentWeekIndex];

    if (currentWeekIndex + 1 == listOfWeeks.length) {
      _getMorePreviousWeeks();
    }

    if (index == 0) {
      _getMoreNextWeeks();
      carouselController.nextPage();
    }

    widget.onWeekChange?.call(currentWeek);
    setState(() {});
  }

  // =================

  bool _isReachMinimum(DateTime dateTime) {
    return widget.minDate.add(const Duration(days: -1)).isBefore(dateTime);
  }

  bool _isReachMaximum(DateTime dateTime) {
    return widget.maxDate.add(const Duration(days: 1)).isAfter(dateTime);
  }

  bool _isNextDisabled() {
    final lastDate = listOfWeeks[currentWeekIndex].last;
    // if (widget.maxDate != null) {
    final lastDateFormatted = DateFormat('yyyy/MM/dd').format(lastDate);
    final maxDateFormatted = DateFormat('yyyy/MM/dd').format(widget.maxDate);
    if (lastDateFormatted == maxDateFormatted) return true;
    // }

    final isAfter =
        // widget.maxDate == null ? false :
        lastDate.isAfter(widget.maxDate);

    return isAfter;
    // return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  bool isBackDisabled() {
    final firstDate = listOfWeeks[currentWeekIndex].first;
    // if (widget.minDate != null) {
    final firstDateFormatted = DateFormat('yyyy/MM/dd').format(firstDate);
    final minDateFormatted = DateFormat('yyyy/MM/dd').format(widget.minDate);
    if (firstDateFormatted == minDateFormatted) return true;
    // }

    final isBefore =
        // widget.minDate == null ? false :
        firstDate.isBefore(widget.minDate);

    return isBefore;
    // return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  bool isCurrentYear() {
    return DateFormat('yyyy').format(currentWeek.first) ==
        DateFormat('yyyy').format(today);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return currentWeek.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              if (widget.showTopNavbar)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.showNavigationButtons == true)
                      GestureDetector(
                        onTap: isBackDisabled() ? null : _onBackClick,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new,
                              size: 17,
                              color: isBackDisabled()
                                  ? (widget.inactiveNavigatorColor ??
                                      Colors.grey)
                                  : theme.primaryColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Back',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: isBackDisabled()
                                    ? (widget.inactiveNavigatorColor ??
                                        Colors.grey)
                                    : theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(),
                    Text(
                      widget.monthFormat?.isEmpty ?? true
                          ? (isCurrentYear()
                              ? DateFormat('MMMM').format(
                                  currentWeek.first,
                                )
                              : DateFormat('MMMM yyyy').format(
                                  currentWeek.first,
                                ))
                          : DateFormat(widget.monthFormat).format(
                              currentWeek.first,
                            ),
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.monthColor ?? theme.primaryColor,
                      ),
                    ),
                    if (widget.showNavigationButtons == true)
                      GestureDetector(
                        onTap: _isNextDisabled() ? null : _onNextClick,
                        child: Row(
                          children: [
                            Text(
                              'Next',
                              style: theme.textTheme.bodyLarge!.copyWith(
                                color: _isNextDisabled()
                                    ? (widget.inactiveNavigatorColor ??
                                        Colors.grey)
                                    : theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 17,
                              color: _isNextDisabled()
                                  ? (widget.inactiveNavigatorColor ??
                                      Colors.grey)
                                  : theme.primaryColor,
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              if (widget.showTopNavbar) const SizedBox(height: 12),
              CarouselSlider(
                controller: carouselController,
                items: [
                  if (listOfWeeks.isNotEmpty)
                    for (int ind = 0; ind < listOfWeeks.length; ind++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int weekIndex = 0;
                                  weekIndex < listOfWeeks[ind].length;
                                  weekIndex++)
                                Builder(
                                  builder: (_) {
                                    final currentDate =
                                        listOfWeeks[ind][weekIndex];
                                    final notdisabled =
                                        _isReachMaximum(currentDate) &&
                                            _isReachMinimum(currentDate);
                                    if (!notdisabled) {
                                      return const Expanded(
                                        child: SizedBox.shrink(),
                                      );
                                    }

                                    final boxSelected = DateFormat('dd-MM-yyyy')
                                            .format(currentDate) ==
                                        DateFormat('dd-MM-yyyy')
                                            .format(selectedDate);

                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          _onDateSelect(
                                            listOfWeeks[ind][weekIndex],
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.all(4),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(14),
                                            color: boxSelected
                                                ? AppTheme.primaryBlue
                                                : Colors.transparent,
                                            border: boxSelected
                                                ? null
                                                : Border.all(
                                                    width: .2,
                                                  ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                DateFormat(
                                                  'EEE',
                                                )
                                                    .format(
                                                      listOfWeeks[ind]
                                                          [weekIndex],
                                                    )
                                                    .toUpperCase(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      AppTheme.poppinsFont,
                                                  fontSize: 12,
                                                  color: boxSelected
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              if (boxSelected)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 4,
                                                    right: 4,
                                                  ),
                                                  alignment: Alignment.center,
                                                  width: double.maxFinite,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '${currentDate.day}',
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          AppTheme.poppinsFont,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                )
                                              else
                                                Text(
                                                  '${currentDate.day}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        AppTheme.poppinsFont,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                ],
                options: CarouselOptions(
                  initialPage: _initialPage,
                  scrollPhysics: const ClampingScrollPhysics(),
                  height: 75,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  reverse: true,
                  onPageChanged: (index, reason) {
                    onWeekChange(index);
                  },
                ),
              ),
            ],
          );
  }
}
