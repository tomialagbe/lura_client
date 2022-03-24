import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/authentication/authentication_repository.dart';
import 'package:lura_client/core/authentication/bloc/authentication_bloc.dart';
import 'package:lura_client/core/authentication/exceptions.dart';
import 'package:lura_client/locator.dart';

class ForgotPasswordScreenState extends Equatable {
  final bool isSubmitting;
  final bool completed;
  final String? error;

  const ForgotPasswordScreenState._(
      {this.isSubmitting = false, this.completed = false, this.error});

  const ForgotPasswordScreenState.initial() : this._();

  ForgotPasswordScreenState submitting() =>
      const ForgotPasswordScreenState._(isSubmitting: true);

  ForgotPasswordScreenState success() =>
      const ForgotPasswordScreenState._(isSubmitting: false, completed: true);

  ForgotPasswordScreenState failed(String message) =>
      ForgotPasswordScreenState._(
          isSubmitting: false, completed: false, error: message);

  @override
  List<Object?> get props => [isSubmitting, completed, error];
}

class ForgotPasswordScreenBloc extends Cubit<ForgotPasswordScreenState> {
  final AuthenticationRepository authenticationRepository;

  ForgotPasswordScreenBloc({AuthenticationRepository? authRepo})
      : authenticationRepository =
            authRepo ?? locator.get<AuthenticationRepository>(),
        super(const ForgotPasswordScreenState.initial());

  Future sendPasswordResetEmail(String emailAddress) async {
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
