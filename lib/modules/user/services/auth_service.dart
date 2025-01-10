import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_quest/common.dart';
import 'package:habit_quest/modules/user/models/quest_user.dart';
import 'package:habit_quest/modules/user/services/rewards_helper.dart';

final firebaseUserStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authServiceProvider =
    StateNotifierProvider<AuthNotifier, QuestUser?>((ref) {
  final user = ref.watch(firebaseUserStreamProvider);
  return AuthNotifier(
    user: user.valueOrNull,
  );
});

class AuthNotifier extends StateNotifier<QuestUser?> {
  AuthNotifier({required this.user}) : super(null) {
    if (user != null) {
      init();
    }
  }
  final User? user;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> init() async {
    try {
      await fetchQuestUser(user!.uid);
    } catch (e) {
      final localUser = CacheStorage.instance.questUser;
      if (localUser != null) {
        state = localUser;
      } else {
        //logout
        debugPrint(e.toString());
      }
    }
  }

  Future<void> fetchQuestUser(String userId) async {
    await usersCollection.doc(userId).get().then((doc) async {
      if (doc.exists && doc.data() != null) {
        state = QuestUser.fromMap(doc.data()!);
      } else {
        final newuser = await createNewQuestUser(
          userId: user!.uid,
          email: user!.email ?? '',
          name: user!.displayName,
        );
        state = newuser;
      }
    });
  }

  Future<void> createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    unawaited(
      FirebaseAnalytics.instance.logSignUp(
        signUpMethod: 'Email/Password',
      ),
    );
  }

  Future<void> googleSignIn() async {
    final UserCredential res;
    // if (kIsWeb) {
    //   final googleProvider = GoogleAuthProvider();
    //   await FirebaseAuth.instance.signInWithRedirect(googleProvider);
    //   res = await FirebaseAuth.instance.getRedirectResult();
    // } else {
    //   final googleUser = await GoogleSignIn(
    //     clientId: kIsWeb ? googleAuthClientId : null,
    //   ).signIn();
    //   final googleAuth = await googleUser?.authentication;
    //   final credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth?.accessToken,
    //     idToken: googleAuth?.idToken,
    //   );
    //   res = await FirebaseAuth.instance.signInWithCredential(credential);
    // }
    final googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? googleAuthClientId : null,
    );

    final googleUser = await googleSignIn.signIn();

    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    res = await FirebaseAuth.instance.signInWithCredential(credential);

    final newUser = res.additionalUserInfo?.isNewUser ?? false;
    if (newUser) {
      unawaited(
        FirebaseAnalytics.instance.logSignUp(
          signUpMethod: 'Google',
        ),
      );
    } else {
      unawaited(
        FirebaseAnalytics.instance.logLogin(
          loginMethod: 'Google',
        ),
      );
    }
  }

  Future<QuestUser> createNewQuestUser({
    required String userId,
    required String email,
    String? name,
  }) async {
    final newuser = QuestUser.newUser(
      userId,
      name ?? '',
      email,
    );
    await usersCollection.doc(userId).set(
          newuser.toMap(),
        );
    await CacheStorage.instance.updateQuestUser(newuser);
    return newuser;
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      unawaited(
        FirebaseAnalytics.instance.logLogin(
          loginMethod: 'Email/Password',
        ),
      );
    } catch (e) {
      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'login_failed',
          parameters: {
            'error': e.toString(),
          },
        ),
      );
      rethrow;
    }
  }

  Future<void> update(QuestUser questuser) async {
    if (user != null) {
      final updateUser = questuser.copyWith(
        updatedAt: DateTime.now(),
      );
      try {
        await usersCollection
            .doc(questuser.id)
            .update(
              updateUser.toMap(),
            )
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        unawaited(
          FirebaseAnalytics.instance.logEvent(
            name: 'update_failed',
            parameters: {
              'error': e.toString(),
            },
          ),
        );
      }
      await CacheStorage.instance.updateQuestUser(updateUser);
      state = updateUser;
    }
  }

  void addCoin(BuildContext context) {
    if (state == null) {
      return;
    }
    final coins = state!.collectedCoins + 1;
    update(state!.copyWith(collectedCoins: coins));
    RewardsHelper.activityCompleted(context, coins);
  }

  Future<void> spendCoins(int coins) async {
    if (user == null) {
      return;
    }
    final newCoins = state!.spentCoins + coins;
    await update(
      state!.copyWith(spentCoins: newCoins),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await AppRepository.instance.clear();
    await CacheStorage.instance.delete();
    if (!kIsWeb) {
      await NotificationHelper.deleteAll();
    }
  }
}
