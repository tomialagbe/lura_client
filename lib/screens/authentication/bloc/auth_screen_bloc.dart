import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/tracking/tracking_service.dart';
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
  final TrackingService trackingService;

  AuthScreenBloc(
      {AuthenticationRepository? authRepo, TrackingService? trackingService})
      : authenticationRepository =
            authRepo ?? locator.get<AuthenticationRepository>(),
        trackingService = trackingService ?? locator.get<TrackingService>(),
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
      trackingService.trackSignup(email);
      emit(state.success());
    } on SignupFailedException catch (e) {
      // _trackSignupFailed(email, e.message);
      emit(state.failed(e.message));
    } catch (e) {
      // _trackSignupFailed(email, 'Unknown');
      emit(state.failed('An unknown error occurred'));
    }
  }

  Future _trackSignupFailed(String email, String error) {
    return trackingService.trackEvent('SIGNUP_FAILED',
        properties: {'\$email': email, '\$error': error});
  }
}

class LoginScreenBloc extends AuthScreenBloc {
  void login(String email, String password) async {
    try {
      emit(state.submitting());
      await authenticationRepository.loginWithEmail(
          email: email, password: password);
      trackingService.trackLogin(email);
      emit(state.success());
    } on LoginFailedException catch (e) {
      // _trackLoginFailed(email, e.message);
      emit(state.failed(e.message));
    } catch (e) {
      // _trackLoginFailed(email, 'Unknown');
      emit(state.failed('An unknown error occurred'));
    }
  }

  Future _trackLoginFailed(String email, String error) {
    return trackingService.trackEvent('LOGIN_FAILED',
        properties: {'\$email': email, '\$error': error});
  }
}

class ForgotPasswordScreenBloc extends AuthScreenBloc {
  void sendPasswordResetEmail(String emailAddress) async {
    try {
      emit(state.submitting());
      await authenticationRepository.sendPasswordResetEmail(emailAddress);
      trackingService
          .trackEvent('PASSWORD_RESET', properties: {'\$email': emailAddress});
      emit(state.success());
    } on ResetPasswordException catch (e) {
      // _trackPasswordResetFailed(emailAddress, e.message);
      emit(state.failed(e.message));
    } catch (e) {
      // _trackPasswordResetFailed(emailAddress, 'Unknown');
      emit(state.failed('An unknown error occurred'));
    }
  }

  Future _trackPasswordResetFailed(String email, String error) {
    return trackingService.trackEvent('PASSWORD_RESET_FAILED',
        properties: {'\$email': email, '\$error': error});
  }
}
