 
import 'package:firebase_login/domain_layer/domain_layer.dart';
import 'package:test/test.dart';

void main() {
  group('User', () {
    const mockId = 'mock-id';
    const mockEmail = 'mock-email';
    const mockUser = User(email: mockEmail, id: mockId);

    test('uses value equality', () {
      expect(mockUser, equals(mockUser));
    });

    test('isEmpty returns true for empty user', () {
      expect(User.empty.isEmpty, isTrue);
    });

    test('isEmpty returns false for non-empty user', () {
      expect(mockUser.isEmpty, isFalse);
    });

    test('isNotEmpty returns false for empty user', () {
      expect(User.empty.isNotEmpty, isFalse);
    });

    test('isNotEmpty returns true for non-empty user', () {
      expect(mockUser.isNotEmpty, isTrue);
    });
  });
}
