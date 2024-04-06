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
    final isValid = Formz.validate([
      email,
      state.password,
      state.confirmedPassword,
    ]);
    emit(state.copyWith(email: email, isValid: isValid));
  }

  void onPasswordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    final isValid = Formz.validate([
      state.email,
      password,
      confirmedPassword,
    ]);
    emit(
      state.copyWith(
        password: password,
        confirmedPassword: confirmedPassword,
        isValid: isValid,
      ),
    );
  }

  void onConfirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value,
      value: value,
    );
    final isValid = Formz.validate([
      state.email,
      state.password,
      confirmedPassword,
    ]);
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        isValid: isValid,
      ),
    );
  }

  Future<void> onSignUpFormSubmitted() async {
    final isInvalid = !state.isValid;
    if (isInvalid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signUp(
        email: state.email.value,
        password: state.password.value,
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
