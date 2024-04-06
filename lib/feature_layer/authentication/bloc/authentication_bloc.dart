import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AuthenticationState.authenticated(
                  authenticationRepository.currentUser,
                )
              : const AuthenticationState.unauthenticated(),
        ) {
    on<_AuthenticationUserChanged>(_onUserChanged);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AuthenticationUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  void _onUserChanged(
    _AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(
      event.user.isNotEmpty
          ? AuthenticationState.authenticated(event.user)
          : const AuthenticationState.unauthenticated(),
    );
  }

  void _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
