import 'package:equatable/equatable.dart';
import 'package:firebase_login/feature_layer/login/models/models.dart';
import 'package:formz/formz.dart';

class LoginForm extends Equatable {
  const LoginForm({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  final Email email;
  final Password password;

  bool get isValid => Formz.validate([email, password]);
  bool get isInvalid => !isValid;

  @override
  List<Object> get props => [email, password];

  LoginForm copyWith({
    Email? email,
    Password? password,
  }) {
    return LoginForm(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
