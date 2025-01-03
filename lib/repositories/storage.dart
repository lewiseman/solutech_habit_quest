import 'package:flutter/foundation.dart';
import 'package:habit_quest/common.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LocalStorage {
  factory LocalStorage() => _instance;
  LocalStorage._();
  static final LocalStorage _instance = LocalStorage._();
  static LocalStorage get instance => _instance;
  late final SharedPreferences _prefs;
  static final String _keySuffix = '$_envName-$_docVersion';

  static const String _docVersion = 'V001';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static final String _themeNameKey = 'thememodekey-$_keySuffix';
  static final String _usercredentialKey = 'usercredentialkey-$_keySuffix';

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
      return theme ?? 'system';
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return 'system';
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
