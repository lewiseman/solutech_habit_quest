import 'package:habit_quest/common.dart';
import 'package:appwrite/models.dart' as models;

class AppUserSettings {
  AppUserSettings({
    required this.themeName,
  });

  factory AppUserSettings.initial({models.User? user}) {
    final livethemename = user?.prefs.data['theme'] as String?;
    final themename = livethemename ?? LocalStorage.instance.themeName;
    return AppUserSettings(
      themeName: themename,
    );
  }
  final String themeName;

  static ThemeMode getThemeMode(String name) {
    switch (name) {
      case 'system':
        return ThemeMode.system;
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
