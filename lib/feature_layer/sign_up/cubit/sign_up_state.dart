part of 'sign_up_cubit.dart';

enum ConfirmPasswordValidationError { invalid }

final class SignUpState extends Equatable {
  const SignUpState({
    this.signUpForm = const SignUpForm(),
    this.status = FormzSubmissionStatus.initial,
    this.errorMessage = 'Sign Up Failure',
  });

  final SignUpForm signUpForm;
  final FormzSubmissionStatus status;
  final String errorMessage;

  @override
  List<Object> get props => [signUpForm, status, errorMessage];

  SignUpState copyWith({
    SignUpForm? signUpForm,
    FormzSubmissionStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      signUpForm: signUpForm ?? this.signUpForm,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
