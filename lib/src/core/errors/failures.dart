sealed class Failure {
  final String? code;
  const Failure({this.code});
}

enum AuthFailureKind {
  invalidEmail,
  userDisabled,
  invalidCredentials,
  tooManyRequests,
  sessionExpired,
  network,
  operationNotAllowed,
  unknown,
}

class AuthFailure extends Failure {
  final AuthFailureKind kind;
  const AuthFailure(this.kind, {super.code});

  factory AuthFailure.fromFirebaseAuthCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthFailure(AuthFailureKind.invalidEmail, code: code);
      case 'user-disabled':
        return AuthFailure(AuthFailureKind.userDisabled, code: code);
      case 'user-not-found':
      case 'wrong-password':
      case 'INVALID_LOGIN_CREDENTIALS':
      case 'invalid-credential':
        return AuthFailure(AuthFailureKind.invalidCredentials, code: code);
      case 'too-many-requests':
        return AuthFailure(AuthFailureKind.tooManyRequests, code: code);
      case 'user-token-expired':
        return AuthFailure(AuthFailureKind.sessionExpired, code: code);
      case 'network-request-failed':
        return AuthFailure(AuthFailureKind.network, code: code);
      case 'operation-not-allowed':
        return AuthFailure(AuthFailureKind.operationNotAllowed, code: code);
      default:
        return AuthFailure(AuthFailureKind.unknown, code: code);
    }
  }
}

enum FirestoreFailureKind { permissionDenied, unavailable, notFound, unknown }

class FirestoreFailure extends Failure {
  final FirestoreFailureKind kind;
  const FirestoreFailure(this.kind, {super.code});

  factory FirestoreFailure.fromFirebaseCode(String code) {
    switch (code) {
      case 'permission-denied':
        return FirestoreFailure(
          FirestoreFailureKind.permissionDenied,
          code: code,
        );
      case 'unavailable':
        return FirestoreFailure(FirestoreFailureKind.unavailable, code: code);
      case 'not-found':
        return FirestoreFailure(FirestoreFailureKind.notFound, code: code);
      default:
        return FirestoreFailure(FirestoreFailureKind.unknown, code: code);
    }
  }
}

enum StorageFailureKind {
  unauthorized,
  canceled,
  quotaExceeded,
  retryLimitExceeded,
  invalidChecksum,
  unknown,
}

class StorageFailure extends Failure {
  final StorageFailureKind kind;

  const StorageFailure(this.kind, [String? code]) : super();

  factory StorageFailure.fromFirebaseCode(String code) {
    switch (code) {
      case 'unauthorized':
      case 'unauthenticated':
        return const StorageFailure(
          StorageFailureKind.unauthorized,
          'unauthorized',
        );
      case 'canceled':
        return const StorageFailure(StorageFailureKind.canceled, 'canceled');
      case 'quota-exceeded':
        return const StorageFailure(
          StorageFailureKind.quotaExceeded,
          'quota-exceeded',
        );
      case 'retry-limit-exceeded':
        return const StorageFailure(
          StorageFailureKind.retryLimitExceeded,
          'retry-limit-exceeded',
        );
      case 'invalid-checksum':
        return const StorageFailure(
          StorageFailureKind.invalidChecksum,
          'invalid-checksum',
        );
      default:
        return StorageFailure(StorageFailureKind.unknown, code);
    }
  }
}

class ServerFailure extends Failure {
  const ServerFailure({super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure({super.code});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({super.code});
}

class InsufficientBalanceFailure extends Failure {
  const InsufficientBalanceFailure({super.code});
}

class AlreadyEnrolledFailure extends Failure {
  const AlreadyEnrolledFailure({super.code});
}

class InstructorCannotPurchaseOwnCourseFailure extends Failure {
  const InstructorCannotPurchaseOwnCourseFailure({super.code});
}
