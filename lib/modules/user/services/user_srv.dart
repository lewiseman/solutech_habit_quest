import 'package:appwrite/enums.dart';
import 'package:appwrite/models.dart' as models;
import 'package:habit_quest/common.dart';
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
      } catch (e) {}
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
          spentCoins != null) {
        final updateduser = await appwriteAccount.updatePrefs(
          prefs: {
            if (avatar != null) 'avatar': avatar,
            if (themeMode != null) 'theme_mode': themeMode,
            if (collectedCoins != null) 'collected_coins': collectedCoins,
            if (spentCoins != null) 'spent_coins': spentCoins,
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
    );
    await Future<void>.delayed(const Duration(seconds: 1));
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
      await appwriteAccount.deleteSession(sessionId: 'current');
    }
    await AppRepository.instance.clear();
    await CacheStorage.instance.delete();
    await NotificationHelper.deleteAll();
    ref.read(appRouteService).refreshUser();
    state = null;
  }
}
