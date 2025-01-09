import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_quest/common.dart';

final authServiceProvider = StateNotifierProvider((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier {
  AuthNotifier() : super(null);
  Future createAccount({
    required String email,
    required String password,
    required String name,
  }) async {
    final res = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseAnalytics.instance.logSignUp(
      signUpMethod: 'Email/Password',
    );
    return res;
  }

  Future<UserCredential> googleSignIn() async {
    final UserCredential res;
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithRedirect(googleProvider);
      res = await FirebaseAuth.instance.getRedirectResult();
    } else {
      final googleUser = await GoogleSignIn(
        clientId: kIsWeb ? googleAuthClientId : null,
      ).signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      res = await FirebaseAuth.instance.signInWithCredential(credential);
    }

    final newUser = res.additionalUserInfo?.isNewUser ?? false;
    if (newUser) {
      FirebaseAnalytics.instance.logSignUp(
        signUpMethod: 'Google',
      );
    } else {
      FirebaseAnalytics.instance.logLogin(
        loginMethod: 'Google',
      );
    }
    return res;
  }

  createNewUser({String? name}) {}

  Future<void> logout() {
    return FirebaseAuth.instance.signOut();
  }
}
