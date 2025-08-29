abstract class Failure {
  final String message;
  final String? code;
  const Failure({required this.message, this.code});
  @override
  String toString() => code == null ? message : '$message ($code)';
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  factory AuthFailure.fromFirebaseAuthCode(String code, [String? msg]) {
    switch (code) {
      case 'invalid-email':
        return AuthFailure(message: 'Invalid email address', code: code);

      case 'user-disabled':
        return AuthFailure(message: 'User has been disabled', code: code);

      case 'user-not-found':
      case 'wrong-password':
      case 'INVALID_LOGIN_CREDENTIALS':
      case 'invalid-credential':
        return AuthFailure(
          message: 'Email or password is incorrect',
          code: code,
        );

      case 'too-many-requests':
        return AuthFailure(
          message: 'Too many attempts. Please try again later.',
          code: code,
        );

      case 'user-token-expired':
        return AuthFailure(
          message: 'Session expired. Please sign in again.',
          code: code,
        );

      case 'network-request-failed':
        return AuthFailure(
          message: 'No internet connection. Please check your network.',
          code: code,
        );

      case 'operation-not-allowed':
        return AuthFailure(
          message: 'Email/password sign-in is not enabled.',
          code: code,
        );

      default:
        return AuthFailure(
          message: msg ?? 'Authentication failed. Please try again.',
          code: code,
        );
    }
  }
}

class FirestoreFailure extends Failure {
  const FirestoreFailure({required super.message, super.code});
  factory FirestoreFailure.fromFirebaseCode(String code, [String? msg]) {
    switch (code) {
      case 'permission-denied':
        return FirestoreFailure(
          message: 'No permission to access profile',
          code: code,
        );
      case 'unavailable':
        return FirestoreFailure(
          message: 'Service unavailable, check connection',
          code: code,
        );
      case 'not-found':
        return FirestoreFailure(message: 'User profile not found', code: code);
      default:
        return FirestoreFailure(message: msg ?? 'Database error', code: code);
    }
  }
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure({String? message})
    : super(message: message ?? 'Unknown error');
}
