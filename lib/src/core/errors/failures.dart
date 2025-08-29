import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  final StackTrace? stackTrace;
  final DateTime timestamp;

  Failure({required this.message, this.code, this.stackTrace})
    : timestamp = DateTime.now();

  @override
  List<Object?> get props => [message, code, stackTrace, timestamp];

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkFailure extends Failure {
  NetworkFailure({required super.message, super.code, super.stackTrace});

  factory NetworkFailure.offline() =>
      NetworkFailure(message: 'No internet connection.');

  factory NetworkFailure.timeout() =>
      NetworkFailure(message: 'The request timed out.');

  factory NetworkFailure.unstable() =>
      NetworkFailure(message: 'The connection seems unstable.');

  factory NetworkFailure.fromDioType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionError:
        return NetworkFailure.offline();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();
      default:
        return NetworkFailure(message: 'A network error occurred.');
    }
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.code, super.stackTrace});

  factory ServerFailure.fromCode(int statusCode) {
    return ServerFailure(
      message: 'Server error ($statusCode).',
      code: statusCode,
    );
  }
}

class AuthFailure extends Failure {
  AuthFailure({required super.message, super.code, super.stackTrace});

  factory AuthFailure.invalidCredentials() =>
      AuthFailure(message: 'Invalid credentials.');

  factory AuthFailure.sessionExpired() =>
      AuthFailure(message: 'Your session has expired. Please sign in again.');

  factory AuthFailure.fromFirebaseCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthFailure(message: 'The email address is not valid.');
      case 'user-disabled':
        return AuthFailure(message: 'This user account has been disabled.');
      case 'user-not-found':
        return AuthFailure(message: 'No user found with this email.');
      case 'wrong-password':
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return AuthFailure(
          message: 'The password is invalid or the credentials are incorrect.',
        );
      case 'too-many-requests':
        return AuthFailure(
          message: 'Too many requests. Please try again later.',
        );
      case 'user-token-expired':
        return AuthFailure.sessionExpired();
      case 'network-request-failed':
        return AuthFailure(message: 'Network error. Please try again.');
      case 'operation-not-allowed':
        return AuthFailure(
          message: 'Email/password login is not enabled in Firebase settings.',
        );
      default:
        return AuthFailure(message: 'Authentication failed. [$code]');
    }
  }
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, super.stackTrace});

  factory CacheFailure.readError() =>
      CacheFailure(message: 'A local storage error occurred.');
}

class ParsingFailure extends Failure {
  ParsingFailure({required super.message, super.code, super.stackTrace});

  factory ParsingFailure.invalid() =>
      ParsingFailure(message: 'Received invalid data.');
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  ValidationFailure({
    required super.message,
    required this.errors,
    super.code,
    super.stackTrace,
  });

  @override
  List<Object?> get props => [...super.props, errors];
}

class PermissionFailure extends Failure {
  PermissionFailure({required String permission, super.code, super.stackTrace})
    : super(message: 'Permission denied: $permission');
}

class RateLimitFailure extends Failure {
  final Duration retryAfter;

  RateLimitFailure(this.retryAfter, {super.stackTrace})
    : super(message: 'Too many requests. Please try again later.', code: 429);

  @override
  List<Object?> get props => [...super.props, retryAfter];
}

class UnimplementedFailure extends Failure {
  UnimplementedFailure()
    : super(message: 'This feature is not implemented yet.');
}

class UnknownFailure extends Failure {
  UnknownFailure({super.stackTrace})
    : super(message: 'An unknown error occurred.');
}
