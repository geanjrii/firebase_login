 
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppState', () {
    group('unauthenticated', () {
      test('has correct status', () {
        const state = AuthenticationState.unauthenticated();
        expect(state.status, AuthenticationStatus.unauthenticated);
        expect(state.user, User.empty);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final mockUser = MockUser();
        final state = AuthenticationState.authenticated(mockUser);
        expect(state.status, AuthenticationStatus.authenticated);
        expect(state.user, mockUser);
      });
    });
  });
}
