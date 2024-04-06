import 'package:firebase_login/app/app.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/authentication/view/authentication_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthenticationRepository()),
      ],
      child: MaterialApp(
        theme: theme,
        home: const AuthenticationView(),
      ),
    );
  }
}
