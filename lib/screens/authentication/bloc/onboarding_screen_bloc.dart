import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/core/api/api.dart';
import 'package:lura_client/core/business/business_bloc.dart';
import 'package:lura_client/core/business/business_repository.dart';
import 'package:lura_client/locator.dart';

class OnboardingScreenState extends Equatable {
  final bool isSubmitting;
  final bool completed;
  final String? error;

  const OnboardingScreenState._(
      {this.isSubmitting = false, this.completed = false, this.error});

  const OnboardingScreenState.initial() : this._();

  OnboardingScreenState submitting() =>
      const OnboardingScreenState._(isSubmitting: true);

  OnboardingScreenState success() =>
      const OnboardingScreenState._(isSubmitting: false, completed: true);

  OnboardingScreenState failed(String message) => OnboardingScreenState._(
      isSubmitting: false, completed: true, error: message);

  @override
  List<Object?> get props => [isSubmitting, completed, error];
}

class OnboardingScreenBloc extends Cubit<OnboardingScreenState> {
  final BusinessRepository businessRepository;
  final BusinessBloc businessBloc;

  OnboardingScreenBloc(
      {BusinessRepository? businessRepo, required this.businessBloc})
      : businessRepository = businessRepo ?? locator.get<BusinessRepository>(),
        super(const OnboardingScreenState.initial());

  void saveBusiness(String businessName) async {
    try {
      emit(state.submitting());
      await businessRepository.saveBusinessForUser(businessName);
      unawaited(businessBloc.loadBusiness());
      emit(state.success());
    } on ResponseException catch (rex) {
      emit(state.failed(rex.responseMessage ?? rex.message));
    } catch (err) {
      emit(state.failed('An unknown error occurred'));
    }
  }
}
