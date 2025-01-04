import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  int remainingTime() {
    final now = TimeOfDay.now();
    final nowInMinutes = now.hour * 60 + now.minute;
    final timeInMinutes = hour * 60 + minute;
    return timeInMinutes - nowInMinutes;
  }

  String remainingStr() {
    final difference = remainingTime();
    final hours = difference ~/ 60;
    final minutes = difference % 60;
    if (hours == 0) {
      return minutes == 1 ? '1 minute' : '$minutes minutes';
    }
    if (minutes == 0) {
      return hours == 1 ? '1 hour' : '$hours hours';
    }
    return '${hours == 1 ? '1 hour' : '$hours hours'} $minutes minutes';
  }
}
