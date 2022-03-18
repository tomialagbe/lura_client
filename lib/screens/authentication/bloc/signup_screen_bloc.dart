import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/locator.dart';

import '../../../core/authentication/authentication_repository.dart';
import '../../../core/authentication/exceptions.dart';

class SignupScreenState extends Equatable {
  final bool isSubmitting;
  final bool completed;
  final String? error;

  const SignupScreenState._(
      {this.isSubmitting = false, this.completed = false, this.error});

  const SignupScreenState.initial() : this._();

  SignupScreenState submitting() =>
      const SignupScreenState._(isSubmitting: true);

  SignupScreenState success() =>
      const SignupScreenState._(isSubmitting: false, completed: true);

  SignupScreenState failed(String message) =>
      SignupScreenState._(isSubmitting: false, completed: true, error: message);

  @override
  List<Object?> get props => [isSubmitting, completed, error];
}

class SignupScreenBloc extends Cubit<SignupScreenState> {
  final AuthenticationRepository authenticationRepository;

  SignupScreenBloc({AuthenticationRepository? authRepo})
      : authenticationRepository =
            authRepo ?? locator.get<AuthenticationRepository>(),
        super(const SignupScreenState.initial());

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
