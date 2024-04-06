import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/authentication/authentication.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationView extends StatelessWidget {
  const AuthenticationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const AuthenticationPage(),
    );
  }
}

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((AuthenticationBloc bloc) => bloc.state.status);
    return FlowBuilder<AuthenticationStatus>(
      state: status,
      onGeneratePages: onGenerateAppViewPages,
    );
  }
}
