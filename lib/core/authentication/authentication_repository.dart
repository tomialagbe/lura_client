import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:lura_client/core/authentication/exceptions.dart';

import 'lura_user.dart';

extension on firebase_auth.User {
  LuraUser get toLuraUser {
    return LuraUser(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }
}

class AuthenticationRepository {
  final firebase_auth.FirebaseAuth firebaseAuth;

  LuraUser? currentUser;

  AuthenticationRepository({required this.firebaseAuth});

  Stream<LuraUser> get user {
    return firebaseAuth.authStateChanges().map((firebaseUser) {
      final luraUser =
          firebaseUser == null ? LuraUser.empty : firebaseUser.toLuraUser;
      if (luraUser != LuraUser.empty) {
        currentUser = luraUser;
      }
      return luraUser;
    });
  }

  Future loginWithEmail(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LoginFailedException.fromCode(e.code);
    } catch (_) {
      throw const LoginFailedException();
    }
  }

  Future signUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseException catch (e) {
      throw SignupFailedException.fromCode(e.code);
    } catch (_) {
      throw const SignupFailedException();
    }
  }

  Future sendPasswordResetEmail(String to) async {
    try {
      return await firebaseAuth.sendPasswordResetEmail(email: to);
    } on firebase_auth.FirebaseException catch (e) {
      throw ResetPasswordException.fromCode(e.code);
    } catch (_) {
      throw const ResetPasswordException();
    }
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }
}
