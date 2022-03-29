import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/locator.dart';

import '../../../core/authentication/authentication_repository.dart';
import '../../../core/authentication/exceptions.dart';

class AuthScreenState extends Equatable {
  final bool isSubmitting;
  final bool completed;
  final String? error;

  const AuthScreenState._(
      {this.isSubmitting = false, this.completed = false, this.error});

  const AuthScreenState.initial() : this._();

  AuthScreenState submitting() => const AuthScreenState._(isSubmitting: true);

  AuthScreenState success() =>
      const AuthScreenState._(isSubmitting: false, completed: true);

  AuthScreenState failed(String message) =>
      AuthScreenState._(isSubmitting: false, completed: true, error: message);

  @override
  List<Object?> get props => [isSubmitting, completed, error];
}

abstract class AuthScreenBloc extends Cubit<AuthScreenState> {
  final AuthenticationRepository authenticationRepository;

  AuthScreenBloc({AuthenticationRepository? authRepo})
      : authenticationRepository =
            authRepo ?? locator.get<AuthenticationRepository>(),
        super(const AuthScreenState.initial());

  void clearError() {
    emit(const AuthScreenState.initial());
  }
}

class SignupScreenBloc extends AuthScreenBloc {
  void signup(String email, String password) async {
    try {
      emit(state.submitting());
      await authenticationRepository.signUpWithEmailAndPassword(
          email: email, password: password);
      emit(state.success());
    } on SignupFailedException catch (e) {
      emit(state.failed(e.message));
    } catch (e) {
      emit(state.failed('An unknown error occurred'));
    }
  }
}

class LoginScreenBloc extends AuthScreenBloc {
  void login(String email, String password) async {
    try {
      emit(state.submitting());
      await authenticationRepository.loginWithEmail(
          email: email, password: password);
      emit(state.success());
    } on LoginFailedException catch (e) {
      emit(state.failed(e.message));
    } catch (e) {
      emit(state.failed('An unknown error occurred'));
    }
  }
}

class ForgotPasswordScreenBloc extends AuthScreenBloc {
  void sendPasswordResetEmail(String emailAddress) async {
    try {
      emit(state.submitting());
      await authenticationRepository.sendPasswordResetEmail(emailAddress);
      emit(state.success());
    } on ResetPasswordException catch (e) {
      emit(state.failed(e.message));
    } catch (e) {
      emit(state.failed('An unknown error occurred'));
    }
  }
}
