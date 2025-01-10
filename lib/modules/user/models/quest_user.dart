import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_quest/config/config.dart';

class QuestUser {
  QuestUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.themeMode,
    required this.collectedCoins,
    required this.spentCoins,
    required this.updatedAt,
    required this.notifications,
  });

  factory QuestUser.fromString(String source) =>
      QuestUser.fromMap(json.decode(source) as Map<String, dynamic>);

  factory QuestUser.newUser(String id, String name, String email) {
    return QuestUser(
      id: id,
      name: name,
      email: email,
      avatar: generalAvatar,
      themeMode: 'light',
      collectedCoins: 0,
      spentCoins: 0,
      updatedAt: DateTime.now(),
      notifications: true,
    );
  }

  factory QuestUser.fromMap(Map<String, dynamic> map) {
    return QuestUser(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      themeMode: map['theme_mode'] as String,
      collectedCoins: map['collected_coins'] as int,
      spentCoins: map['spent_coins'] as int,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      notifications: map['notifications'] as bool,
    );
  }

  factory QuestUser.fromDocumentSnapshot(DocumentSnapshot snap) {
    final map = snap.data()! as Map<String, dynamic>;
    return QuestUser(
      id: snap.id,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String,
      themeMode: map['theme_mode'] as String,
      collectedCoins: map['collected_coins'] as int,
      spentCoins: map['spent_coins'] as int,
      updatedAt: DateTime.parse(map['updated_at'] as String),
      notifications: map['notifications'] as bool,
    );
  }

  QuestUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? themeMode,
    int? collectedCoins,
    int? spentCoins,
    DateTime? updatedAt,
    bool? notifications,
  }) {
    return QuestUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      themeMode: themeMode ?? this.themeMode,
      collectedCoins: collectedCoins ?? this.collectedCoins,
      spentCoins: spentCoins ?? this.spentCoins,
      updatedAt: updatedAt ?? this.updatedAt,
      notifications: notifications ?? this.notifications,
    );
  }

  final String id;
  final String name;
  final String email;
  final String avatar;
  final String themeMode;
  final int collectedCoins;
  final int spentCoins;
  final DateTime updatedAt;
  final bool notifications;

  @override
  String toString() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'theme_mode': themeMode,
      'collected_coins': collectedCoins,
      'spent_coins': spentCoins,
      'notifications': notifications,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  int getCoinBalance() {
    final balance = collectedCoins - spentCoins;
    if (balance < 0) {
      return 0;
    }
    return balance;
  }
}
