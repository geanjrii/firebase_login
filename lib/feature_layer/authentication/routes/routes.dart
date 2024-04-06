import 'package:firebase_login/feature_layer/authentication/authentication.dart';
import 'package:firebase_login/feature_layer/home/home.dart';
import 'package:firebase_login/feature_layer/login/login.dart';
import 'package:flutter/widgets.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AuthenticationStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AuthenticationStatus.authenticated:
      return [HomePage.page()];
    case AuthenticationStatus.unauthenticated:
      return [LoginPage.page()];
  }
}
