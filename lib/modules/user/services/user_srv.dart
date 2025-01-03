import 'package:appwrite/models.dart' as models;
import 'package:habit_quest/common.dart';
import 'package:habit_quest/router.dart';

final userServiceProvider =
    StateNotifierProvider<UserServiceNotifier, models.User?>(
  (ref) => UserServiceNotifier(
    ref: ref,
    userCredentials: LocalStorage.instance.userCredentials,
  ),
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
      final user = await login(
        email: userCredentials!.email,
        password: userCredentials!.password,
      );
      state = user;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint(e.toString());
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
  }) async {
    try {
      await appwriteAccount.createEmailPasswordSession(
        email: email,
        password: password,
      );
      final user = await appwriteAccount.get();
      await LocalStorage.instance.updateUserCreds(
        UserCredentials(
          email: email,
          password: password,
          name: name ?? user.name,
        ),
      );
      return user;
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

  Future<void> logout() async {
    await appwriteAccount.deleteSession(sessionId: 'current');
    await LocalStorage.instance.delete();
    ref.read(appRouteService).refreshUser();
    state = null;
  }
}
