import 'package:habit_quest/common.dart';

class EventList<T> {
  EventList({
    required this.events,
  });
  Map<DateTime, List<T>> events;

  void add(DateTime date, T event) {
    final eventsOfDate = events[date];
    if (eventsOfDate == null)
      events[date] = [event];
    else
      eventsOfDate.add(event);
  }

  void addAll(DateTime date, List<T> events) {
    final eventsOfDate = this.events[date];
    if (eventsOfDate == null)
      this.events[date] = events;
    else
      eventsOfDate.addAll(events);
  }

  bool remove(DateTime date, T event) {
    final eventsOfDate = events[date];
    return eventsOfDate != null ? eventsOfDate.remove(event) : false;
  }

  List<T> removeAll(DateTime date) {
    return events.remove(date) ?? [];
  }

  void clear() {
    events.clear();
  }

  List<T> getEvents(DateTime date) {
    return events[date] ?? [];
  }
}

class Event implements EventInterface {
  Event({
    required this.date,
    this.id,
    this.title,
    this.description,
    this.location,
    this.icon,
    this.dot,
  });
  final DateTime date;
  final String? title;
  final String? description;
  final String? location;
  final Widget? icon;
  final Widget? dot;
  final int? id;

  @override
  bool operator ==(dynamic other) {
    return date == other.date &&
        title == other.title &&
        description == other.description &&
        location == other.location &&
        icon == other.icon &&
        dot == other.dot &&
        id == other.id;
  }

  @override
  int get hashCode => Object.hash(date, description, location, title, icon, id);

  @override
  DateTime getDate() {
    return date;
  }

  @override
  int? getId() {
    return id;
  }

  @override
  Widget? getDot() {
    return dot;
  }

  @override
  Widget? getIcon() {
    return icon;
  }

  @override
  String? getTitle() {
    return title;
  }

  @override
  String? getDescription() {
    return description;
  }

  @override
  String? getLocation() {
    return location;
  }
}

abstract class EventInterface {
  DateTime getDate();
  String? getTitle();
  String? getDescription();
  String? getLocation();
  Widget? getIcon();
  Widget? getDot();
  int? getId();
}

class MarkedDate implements MarkedDateInterface {
  MarkedDate({
    required this.color,
    required this.date,
    this.id,
    this.textStyle,
  });
  final Color color;
  final int? id;
  final TextStyle? textStyle;
  final DateTime date;

  @override
  bool operator ==(dynamic other) {
    return date == other.date &&
        color == other.color &&
        textStyle == other.textStyle &&
        id == other.id;
  }

  @override
  DateTime getDate() => date;

  @override
  int? getId() => id;

  @override
  Color getColor() => color;

  @override
  TextStyle? getTextStyle() => textStyle;
}

abstract class MarkedDateInterface {
  DateTime getDate();
  Color getColor();
  int? getId();
  TextStyle? getTextStyle();
}

class MultipleMarkedDates {
  MultipleMarkedDates({required this.markedDates});
  List<MarkedDate> markedDates;

  void add(MarkedDate markedDate) {
    markedDates.add(markedDate);
  }

  void addRange(MarkedDate markedDate, {int plus = 0, int minus = 0}) {
    add(markedDate);

    if (plus > 0) {
      var start = 1;
      MarkedDate newAddMarkedDate;

      while (start <= plus) {
        newAddMarkedDate = MarkedDate(
          color: markedDate.color,
          date: markedDate.date.add(Duration(days: start)),
          textStyle: markedDate.textStyle,
        );

        add(newAddMarkedDate);

        start += 1;
      }
    }

    if (minus > 0) {
      var start = 1;
      MarkedDate newSubMarkedDate;

      while (start <= minus) {
        newSubMarkedDate = MarkedDate(
          color: markedDate.color,
          date: markedDate.date.subtract(Duration(days: start)),
          textStyle: markedDate.textStyle,
        );

        add(newSubMarkedDate);

        start += 1;
      }
    }
  }

  void addAll(List<MarkedDate> markedDates) {
    this.markedDates.addAll(markedDates);
  }

  bool remove(MarkedDate markedDate) {
    return markedDates.remove(markedDate);
  }

  void clear() {
    markedDates.clear();
  }

  bool isMarked(DateTime date) {
    final results = markedDates.firstWhere(
      (element) => element.date == date,
      orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)),
    );
    return results.date.year == date.year;
  }

  Color getColor(DateTime date) {
    final results = markedDates.firstWhere(
      (element) => element.date == date,
      orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)),
    );
    return results.color;
  }

  DateTime getDate(DateTime date) {
    final results = markedDates.firstWhere(
      (element) => element.date == date,
      orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)),
    );
    return results.date;
  }

  TextStyle? getTextStyle(DateTime date) {
    final results = markedDates.firstWhere(
      (element) => element.date == date,
      orElse: () => MarkedDate(color: Colors.black, date: DateTime(0)),
    );
    return results.textStyle;
  }
}
