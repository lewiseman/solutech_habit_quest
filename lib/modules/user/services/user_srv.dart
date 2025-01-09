import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter/foundation.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/user/services/rewards_helper.dart';
import 'package:habit_quest/router.dart';

final userServiceProvider =
    StateNotifierProvider<UserServiceNotifier, models.User?>(
  (ref) {
    return UserServiceNotifier(
      ref: ref,
      userCredentials: CacheStorage.instance.userCredentials,
    );
  },
);

class UserServiceNotifier extends StateNotifier<models.User?> {
  UserServiceNotifier({
    required this.ref,
    required this.userCredentials,
  }) : super(null) {
    if (userCredentials != null) {
      init();
    }
  }
  final Ref ref;
  final UserCredentials? userCredentials;

  Future<void> init() async {
    try {
      final initialuser = CacheStorage.instance.userPrefs?.toUser(state);
      state = initialuser;
    } catch (e) {}
    try {
      final user = await login(
        email: userCredentials!.email,
        password: userCredentials!.password,
        provider: userCredentials!.provider,
      );
      state = user;
      updateLocalPrefs(user);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      try {
        final localPrefs = CacheStorage.instance.userPrefs;
        if (localPrefs != null) {
          state = localPrefs.toUser(null);
        }
      } catch (e) {
        await logout();
      }
      debugPrint(e.toString());
    }
  }

  void updateLocalPrefs(models.User user) {
    final userPrefs = CacheStorage.instance.userPrefs;
    if (userPrefs == null) {
      CacheStorage.instance.updateUserPrefs(
        LocalUserPrefs.fromUser(user),
      );
      return;
    }
    if (userPrefs.updatedAt.isAfter(DateTime.parse(user.$updatedAt))) {
      update(
        avatar: userPrefs.avatar,
        themeMode: userPrefs.themeMode,
        collectedCoins: userPrefs.collectedCoins,
        spentCoins: userPrefs.spentCoins,
      );
      return;
    }
  }

  void addCoin(BuildContext context) {
    final collectedCoins = state?.collectedCoins();
    if (collectedCoins == null) {
      return;
    }
    final coins = collectedCoins + 1;
    update(collectedCoins: coins);
    RewardsHelper.activityCompleted(context, coins);
  }

  Future<void> spendCoins(int coins) async {
    final spentCoins = state?.spentCoins();
    if (spentCoins == null) {
      return;
    }
    final newCoins = spentCoins + coins;
    await update(spentCoins: newCoins);
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await appwriteAccount.create(
      userId: ID.unique(),
      email: email,
      password: password,
      name: name,
    );

    final user = await login(email: email, password: password, name: name);
    ref.read(appRouteService).refreshUser();
    state = user;
  }

  Future<models.User> login({
    required String email,
    required String password,
    String? name,
    String? provider,
  }) async {
    try {
      await appwriteAccount.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final user = await appwriteAccount.get();
      await CacheStorage.instance.updateUserCreds(
        UserCredentials(
          userId: user.$id,
          email: email,
          password: password,
          name: name ?? user.name,
          provider: 'email',
        ),
      );
      await CacheStorage.instance.updateUserPrefs(
        LocalUserPrefs.fromUser(user),
      );
      return user;
    } on AppwriteException catch (e) {
      if (e.type == 'user_session_already_exists') {
        try {
          final user = await appwriteAccount.get();
          await CacheStorage.instance.updateUserCreds(
            UserCredentials(
              userId: user.$id,
              email: email,
              password: password,
              name: name ?? user.name,
              provider: provider ?? 'email',
            ),
          );
          await CacheStorage.instance.updateUserPrefs(
            LocalUserPrefs.fromUser(user),
          );
          return user;
        } catch (e) {
          rethrow;
        }
      }
      if (e.code == 401) {
        throw 'Invalid email or password';
      }
      rethrow;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> newLogin({
    required String email,
    required String password,
  }) async {
    final user = await login(email: email, password: password);
    ref.read(appRouteService).refreshUser();
    state = user;
  }

  Future<void> update({
    String? name,
    String? avatar,
    String? themeMode,
    int? collectedCoins,
    int? spentCoins,
    bool? notifications,
  }) async {
    var user = state;
    try {
      if (name != null) {
        final updateduser = await appwriteAccount.updateName(name: name);
        user = updateduser;
      }
      if (avatar != null ||
          themeMode != null ||
          collectedCoins != null ||
          spentCoins != null ||
          notifications != null) {
        final updateduser = await appwriteAccount.updatePrefs(
          prefs: {
            'avatar': avatar ?? user!.prefs.data['avatar'] as String? ?? '',
            'theme_mode': themeMode ??
                user?.prefs.data['theme_mode'] as String? ??
                'light',
            'collected_coins': collectedCoins ??
                user?.prefs.data['collected_coins'] as int? ??
                0,
            'spent_coins':
                spentCoins ?? user?.prefs.data['spent_coins'] as int? ?? 0,
            'notifications': notifications ??
                user?.prefs.data['notifications'] as bool? ??
                true,
          },
        );
        user = updateduser;
      }
      try {
        if (user != null) {
          await CacheStorage.instance.updateUserPrefs(
            LocalUserPrefs.fromUser(user),
          );
        }
      } catch (e) {}
    } catch (e) {
      debugPrint(e.toString());
      final LocalUserPrefs? localPrefs;
      localPrefs = CacheStorage.instance.userPrefs;
      if (localPrefs == null) {
        return;
      }
      final updated = localPrefs.copyWith(
        avatar: avatar ?? localPrefs.avatar,
        themeMode: themeMode ?? localPrefs.themeMode,
        collectedCoins: collectedCoins ?? localPrefs.collectedCoins,
        spentCoins: spentCoins ?? localPrefs.spentCoins,
      );
      await CacheStorage.instance.updateUserPrefs(updated);
      if (state != null) {
        user = updated.toUser(state);
      }
    }

    state = user;
  }

  Future<void> googleSignIn() async {
    await appwriteAccount.createOAuth2Session(
      provider: OAuthProvider.google,
      success: 'https://www.papps.io/auth_redirect.html',
    );
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final user = await appwriteAccount.get();
    await CacheStorage.instance.updateUserCreds(
      UserCredentials(
        userId: user.$id,
        email: user.email,
        password: '',
        name: user.name,
        provider: 'google',
      ),
    );
    ref.read(appRouteService).refreshUser();
    state = user;
  }

  Future<void> logout() async {
    if (CacheStorage.instance.userCredentials?.provider != 'google') {
      try {
        await appwriteAccount.deleteSession(sessionId: 'current');
      } catch (e) {}
    }
    await AppRepository.instance.clear();
    await CacheStorage.instance.delete();
    if (!kIsWeb) {
      await NotificationHelper.deleteAll();
    }
    ref.read(appRouteService).refreshUser();
    state = null;
  }
}
