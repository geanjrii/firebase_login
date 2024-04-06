import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void onEmailChanged(String value) {
    final email = Email.dirty(value);
    final isValid = Formz.validate([email, state.password]);
    emit(state.copyWith(email: email, isValid: isValid));
  }

  void onPasswordChanged(String value) {
    final password = Password.dirty(value);
    final isValid = Formz.validate([state.email, password]);
    emit(state.copyWith(password: password, isValid: isValid));
  }

  Future<void> onLogInWithCredentials() async {
    final isInvalid = !state.isValid;
    if (isInvalid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.logInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
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

  Future<void> onLogInWithGoogle() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on LogInWithGoogleFailure catch (e) {
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
