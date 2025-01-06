import 'package:flutter/foundation.dart';
import 'package:habit_quest/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class CacheStorage {
  factory CacheStorage() => _instance;
  CacheStorage._();
  static final CacheStorage _instance = CacheStorage._();
  static CacheStorage get instance => _instance;
  late final SharedPreferences _prefs;
  static final String _keySuffix = '$_envName-$_docVersion';

  static const String _docVersion = 'V001';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final String _themeNameKey = 'thememodekey-$_keySuffix';
  static final String _usercredentialKey = 'usercredentialkey-$_keySuffix';
  static final String _coinsKey = 'coinskey-$_keySuffix';

  UserCredentials? get userCredentials {
    try {
      final userCredsString = _prefs.getString(_usercredentialKey);
      if (userCredsString != null && userCredsString.isNotEmpty) {
        final authUser = UserCredentials.fromString(userCredsString);
        return authUser;
      }
      return null;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserCreds(UserCredentials userCreds) async {
    await _prefs.setString(_usercredentialKey, userCreds.toString());
  }

  Future<void> updateThemeName(String themename) async {
    final res = await _prefs.setString(
      _themeNameKey,
      themename,
    );
  }

  String get themeName {
    try {
      final theme = _prefs.getString(_themeNameKey);
      return theme ?? 'light';
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return 'light';
    }
  }

  Future<void> updateCoins(int coin) async {
    final res = await _prefs.setInt(
      _coinsKey,
      coin,
    );
  }

  int get coins {
    try {
      final coins = _prefs.getInt(_coinsKey);
      return coins ?? 0;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return 0;
    }
  }

  Future<void> delete() async {
    await _prefs.clear();
  }
}

final String _envName = () {
  if (kReleaseMode) {
    return 'Prod';
  } else if (kProfileMode) {
    return 'Test';
  } else {
    return 'Dev';
  }
}();
