 
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:firebase_login/feature_layer/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    final mockUser = MockUser();
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => authenticationRepository.currentUser,
      ).thenReturn(User.empty);
    });

    AuthenticationBloc buildBloc() {
      return AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      );
    }

    test('initial state is unauthenticated when user is empty', () {
      expect(
        buildBloc().state,
        const AuthenticationState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits authenticated when user is not empty',
        setUp: () {
          when(() => mockUser.isNotEmpty).thenReturn(true);
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(mockUser),
          );
        },
        build: buildBloc,
        seed: AuthenticationState.unauthenticated,
        expect: () => [AuthenticationState.authenticated(mockUser)],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits unauthenticated when user is empty',
        setUp: () {
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(User.empty),
          );
        },
        build: buildBloc,
        expect: () => [const AuthenticationState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'invokes logOut',
        setUp: () {
          when(
            () => authenticationRepository.logOut(),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const AuthenticationLogoutRequested()),
        verify: (_) {
          verify(() => authenticationRepository.logOut()).called(1);
        },
      );
    });
  });
}
