import 'package:equatable/equatable.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:formz/formz.dart';

final class SignUpForm extends Equatable {
  const SignUpForm({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
  });

  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;

  bool get isValid => Formz.validate([email, password, confirmedPassword]);
  bool get isInvalid => !isValid;

  @override
  List<Object> get props => [email, password, confirmedPassword];

  SignUpForm copyWith({
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
  }) {
    return SignUpForm(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
    );
  }
}
