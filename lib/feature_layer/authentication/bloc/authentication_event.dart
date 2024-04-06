part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationLogoutRequested extends AuthenticationEvent {
  const AuthenticationLogoutRequested();
}

final class _AuthenticationUserChanged extends AuthenticationEvent {
  const _AuthenticationUserChanged(this.user);

  final User user;
}
