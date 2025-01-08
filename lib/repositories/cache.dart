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
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static final String _usercredentialKey = 'usercredentialkey-$_keySuffix';
  static final String _userprefsKey = 'userprefskey-$_keySuffix';

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

  LocalUserPrefs? get userPrefs {
    try {
      final userPrefsString = _prefs.getString(_userprefsKey);
      if (userPrefsString != null && userPrefsString.isNotEmpty) {
        final authUser = LocalUserPrefs.fromString(userPrefsString);
        return authUser;
      }
      return null;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      return null;
    }
  }

  Future<void> updateUserPrefs(LocalUserPrefs userPrefs) async {
    final res = await _prefs.setString(_userprefsKey, userPrefs.toString());
    print(res);
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
