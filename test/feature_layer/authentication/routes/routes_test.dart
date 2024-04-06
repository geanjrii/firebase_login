import 'package:firebase_login/feature_layer/authentication/authentication.dart';
import 'package:firebase_login/feature_layer/home/home.dart';
import 'package:firebase_login/feature_layer/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('onGenerateAppViewPages', () {
    test('returns [HomePage] when authenticated', () {
      expect(
        onGenerateAppViewPages(AuthenticationStatus.authenticated, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<HomePage>(),
          ),
        ],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AuthenticationStatus.unauthenticated, []),
        [
          isA<MaterialPage<void>>().having(
            (p) => p.child,
            'child',
            isA<LoginPage>(),
          ),
        ],
      );
    });
  });
}
