import 'package:appwrite/models.dart' as models;
import 'package:habit_quest/common.dart';

final settingsServiceProvider =
    StateNotifierProvider<SettingsNotifier, AppUserSettings>((ref) {
  return SettingsNotifier(
    user: ref.watch(userServiceProvider),
  );
});

class SettingsNotifier extends StateNotifier<AppUserSettings> {
  SettingsNotifier({
    required this.user,
  }) : super(AppUserSettings.initial(user: user));

  final models.User? user;

  Future<void> updateTheme(String themeName) async {
    await CacheStorage.instance.updateThemeName(themeName);
    try {
      await appwriteAccount.updatePrefs(
        prefs: {
          'theme': themeName,
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    state = AppUserSettings(
      themeName: themeName,
    );
  }
}
