part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.loginForm = const LoginForm(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage = 'Authentication Failure',
  });

  final LoginForm loginForm;
  final FormzSubmissionStatus status;
  final String errorMessage;

  @override
  List<Object> get props => [loginForm, status,  errorMessage];

  LoginState copyWith({
    LoginForm? loginForm,
    FormzSubmissionStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return LoginState(
      loginForm: loginForm ?? this.loginForm,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
