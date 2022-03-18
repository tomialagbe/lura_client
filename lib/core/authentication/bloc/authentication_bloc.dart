import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lura_client/locator.dart';

import '../authentication_repository.dart';
import '../lura_user.dart';

enum AuthenticationSatus { authenticated, unauthenticated }

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object?> get props => [];
}

class LogoutRequested extends AuthenticationEvent {}

class UserChanged extends AuthenticationEvent {
  final LuraUser user;

  const UserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticationState extends Equatable {
  final AuthenticationSatus status;
  final LuraUser user;

  const AuthenticationState._(
      {required this.status, this.user = LuraUser.empty});

  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationSatus.unauthenticated);

  const AuthenticationState.authenticated(LuraUser user)
      : this._(status: AuthenticationSatus.authenticated, user: user);

  @override
  List<Object?> get props => [user, status];
}

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository authenticationRepository;

  // final TrackingService trackingService;
  // final DeviceBloc deviceBloc;
  late final StreamSubscription<LuraUser> _userSubscription;

  AuthenticationBloc({
    AuthenticationRepository? authRepo,
    // TrackingService? trackingService,
    // required this.deviceBloc,
  })  : authenticationRepository =
            authRepo ?? locator.get<AuthenticationRepository>(),
        // trackingService = trackingService ?? locator.get<TrackingService>(),
        super(const AuthenticationState.unauthenticated()) {
    on<UserChanged>(_onUserChanged);
    on<LogoutRequested>(_onLogoutRequested);
    _userSubscription = authenticationRepository.user.listen((user) {
      add(UserChanged(user));
    });
  }

  void _onUserChanged(UserChanged event, Emitter<AuthenticationState> emit) {
    if (event.user == LuraUser.empty) {
      emit(const AuthenticationState.unauthenticated());
    } else {
      // trackingService.setUser(event.user);
      emit(AuthenticationState.authenticated(event.user));
    }
  }

  void _onLogoutRequested(
      LogoutRequested event, Emitter<AuthenticationState> emit) {
    // unawaited(deviceBloc.unregisterDeviceInfo());
    unawaited(authenticationRepository.logout());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    // trackingService.reset();
    return super.close();
  }
}
