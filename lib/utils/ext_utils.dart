import 'package:appwrite/models.dart' as models;
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

  TimeOfDay removeMinutes(int minutes) {
    final timeInMinutes = hour * 60 + minute;
    final newTimeInMinutes = timeInMinutes - minutes;
    final newHour = newTimeInMinutes ~/ 60;
    final newMinute = newTimeInMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  String removeMinutesStr(int minutes) {
    return removeMinutes(minutes).toTimeString();
  }

  String toTimeString() {
    return '''${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}''';
  }
}

extension MyUser on models.User? {
  int collectedCoins() {
    if (this == null) return 0;
    return this!.prefs.data['collected_coins'] as int? ?? 0;
  }

  int spentCoins() {
    if (this == null) return 0;
    return this!.prefs.data['spent_coins'] as int? ?? 0;
  }

  int getCoinBalance() {
    if (this == null) return 0;
    final totalCoins = this!.prefs.data['collected_coins'] as int? ?? 0;
    final spentCoins = this!.prefs.data['spent_coins'] as int? ?? 0;
    final balance = totalCoins - spentCoins;
    if (balance < 0) {
      return 0;
    }
    return balance;
  }
}

extension MyNims on num {
  num get maxPercentage {
    if (this > 100) {
      return 100;
    }
    return this;
  }
}
