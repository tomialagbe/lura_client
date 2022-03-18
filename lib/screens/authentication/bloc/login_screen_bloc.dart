import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/locator.dart';

import '../../../core/authentication/authentication_repository.dart';
import '../../../core/authentication/exceptions.dart';

class LoginScreenState extends Equatable {
  final bool isSubmitting;
  final bool completed;
  final String? error;

  const LoginScreenState._(
      {this.isSubmitting = false, this.completed = false, this.error});

  const LoginScreenState.initial() : this._();

  LoginScreenState submitting() => const LoginScreenState._(isSubmitting: true);

  LoginScreenState success() =>
      const LoginScreenState._(isSubmitting: false, completed: true);

  LoginScreenState failed(String message) =>
      LoginScreenState._(isSubmitting: false, completed: true, error: message);

  @override
  List<Object?> get props => [isSubmitting, completed, error];
}

class LoginScreenBloc extends Cubit<LoginScreenState> {
  final AuthenticationRepository authenticationRepository;

  LoginScreenBloc({AuthenticationRepository? authRepo})
      : authenticationRepository =
            authRepo ?? locator.get<AuthenticationRepository>(),
        super(const LoginScreenState.initial());

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
