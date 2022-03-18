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

  // Future onBoardAnonymously() async {
  //   _isOnboarding = true;
  //   final credential = await firebaseAuth.signInAnonymously();
  //   final resp = await apiClient
  //       .post('/onboarding/anonymous?userId=${credential.user!.uid}');
  //   if (resp!.statusCode != 201) {
  //     _isOnboarding = false;
  //     if (firebaseAuth.currentUser != null) {
  //       await firebaseAuth.currentUser?.delete();
  //     } else {
  //       await firebaseAuth.signOut();
  //     }
  //     throw ResponseException(
  //         statusCode: resp.statusCode!,
  //         message: 'Failed to onboard anonymously');
  //   }
  //   _isOnboarding = false;
  //   if (_tmpUser != null) {
  //     _tmpUsers.add(_tmpUser!);
  //   }
  // }

  // Future signUp({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     await firebaseAuth.signInAnonymously();
  //     final reqBody = {
  //       'displayName': displayName,
  //       'email': email,
  //       'password': password,
  //     };
  //     await apiClient.post('/onboarding/signup', data: reqBody);
  //     _isOnboarding = false;
  //     await firebaseAuth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //   } on ResponseException catch (_) {
  //     firebaseAuth.currentUser?.delete();
  //     _isOnboarding = false;
  //     throw const SignupFailedException();
  //   } on TimeoutException catch (_) {
  //     firebaseAuth.currentUser?.delete();
  //     _isOnboarding = false;
  //     throw const SignupFailedException();
  //   } on firebase_auth.FirebaseAuthException catch (_) {
  //     _isOnboarding = false;
  //     throw const SignupFailedException();
  //   }
  // }

  Future logout() async {
    await firebaseAuth.signOut();
  }
}
