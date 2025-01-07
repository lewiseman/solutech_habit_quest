import 'dart:convert';
import 'package:appwrite/models.dart' as models;
import 'package:habit_quest/repositories/cache.dart';

class UserCredentials {
  const UserCredentials({
    required this.email,
    required this.password,
    required this.name,
    required this.provider,
    required this.userId,
  });

  factory UserCredentials.fromString(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    return UserCredentials.fromJson(jsonMap as Map<String, dynamic>);
  }

  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      provider: json['provider'] as String,
      userId: json['user_id'] as String,
    );
  }
  final String email;
  final String password;
  final String name;
  final String provider;
  final String userId;

  Map<String, String> toJson() => {
        'email': email,
        'password': password,
        'name': name,
        'provider': provider,
        'user_id': userId,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class LocalUserPrefs {
  const LocalUserPrefs({
    required this.avatar,
    required this.themeMode,
    required this.collectedCoins,
    required this.spentCoins,
    required this.updatedAt,
  });

  factory LocalUserPrefs.fromUser(models.User user) {
    final prefs = user.prefs.data;
    return LocalUserPrefs(
      avatar: prefs['avatar'] as String? ??
          'https://api.dicebear.com/9.x/adventurer-neutral/svg?radius=50',
      themeMode: prefs['theme_mode'] as String? ?? 'light',
      collectedCoins: prefs['collected_coins'] as int? ?? 0,
      spentCoins: prefs['spent_coins'] as int? ?? 0,
      updatedAt: DateTime.tryParse(user.$updatedAt) ?? DateTime.now(),
    );
  }

  factory LocalUserPrefs.fromJson(Map<String, dynamic> json) {
    return LocalUserPrefs(
      avatar: json['avatar'] as String,
      themeMode: json['theme_mode'] as String,
      collectedCoins: json['collected_coins'] as int,
      spentCoins: json['spent_coins'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  factory LocalUserPrefs.fromString(String jsonString) {
    final jsonMap = jsonDecode(jsonString);
    return LocalUserPrefs.fromJson(jsonMap as Map<String, dynamic>);
  }
  final String avatar;
  final String themeMode;
  final int collectedCoins;
  final int spentCoins;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
        'avatar': avatar,
        'theme_mode': themeMode,
        'collected_coins': collectedCoins,
        'spent_coins': spentCoins,
        'updated_at': updatedAt.toIso8601String(),
      };

  LocalUserPrefs copyWith({
    String? avatar,
    String? themeMode,
    int? collectedCoins,
    int? spentCoins,
    DateTime? updatedAt,
  }) {
    return LocalUserPrefs(
      avatar: avatar ?? this.avatar,
      themeMode: themeMode ?? this.themeMode,
      collectedCoins: collectedCoins ?? this.collectedCoins,
      spentCoins: spentCoins ?? this.spentCoins,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  models.User toUser(models.User? user) {
    final creds = CacheStorage.instance.userCredentials;
    return models.User(
      $id: user?.$id ?? creds?.userId ?? '',
      $createdAt: user?.$createdAt ?? '',
      $updatedAt: user?.$updatedAt ?? '',
      name: user?.name ?? creds?.name ?? '',
      registration: user?.registration ?? '',
      status: user?.status ?? true,
      labels: user?.labels ?? [],
      passwordUpdate: user?.passwordUpdate ?? '',
      email: user?.email ?? creds?.email ?? '',
      phone: user?.phone ?? '',
      emailVerification: user?.emailVerification ?? false,
      phoneVerification: user?.phoneVerification ?? false,
      mfa: user?.mfa ?? false,
      prefs: models.Preferences(
        data: {
          'avatar': avatar,
          'theme_mode': themeMode,
          'collected_coins': collectedCoins,
          'spent_coins': spentCoins,
        },
      ),
      targets: user?.targets ?? [],
      accessedAt: user?.accessedAt ?? '',
    );
  }
}
