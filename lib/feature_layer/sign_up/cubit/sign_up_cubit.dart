import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:formz/formz.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  void onEmailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(signUpForm: state.signUpForm.copyWith(email: email)));
  }

  void onPasswordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
        password: value, value: state.signUpForm.confirmedPassword.value);
    emit(state.copyWith(
        signUpForm: state.signUpForm.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
    )));
  }

  void onConfirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.signUpForm.password.value,
      value: value,
    );
    emit(state.copyWith(
        signUpForm:
            state.signUpForm.copyWith(confirmedPassword: confirmedPassword)));
  }

  Future<void> onSignUpFormSubmitted() async {
    if (state.signUpForm.isInvalid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.signUpForm.email.value,
        password: state.signUpForm.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzSubmissionStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
