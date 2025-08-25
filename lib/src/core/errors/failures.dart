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

  factory NetworkFailure.offline() => NetworkFailure(
    message: Translation.translate(
      'noInternetConnection',
      languageCode: Translation.activeLanguage,
    ),
  );

  factory NetworkFailure.timeout() => NetworkFailure(
    message: Translation.translate(
      'requestTimeout',
      languageCode: Translation.activeLanguage,
    ),
  );

  factory NetworkFailure.unstable() => NetworkFailure(
    message: Translation.translate(
      'unstableConnection',
      languageCode: Translation.activeLanguage,
    ),
  );

  factory NetworkFailure.fromDioType(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.connectionError:
        return NetworkFailure.offline();
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure.timeout();
      default:
        return NetworkFailure(
          message: Translation.translate(
            'networkError',
            languageCode: Translation.activeLanguage,
          ),
        );
    }
  }
}

class ServerFailure extends Failure {
  ServerFailure({required super.message, super.code, super.stackTrace});

  factory ServerFailure.fromCode(int statusCode) {
    final key = 'serverError_$statusCode';
    return ServerFailure(
      message: Translation.translate(
        key,
        languageCode: Translation.activeLanguage,
      ),
      code: statusCode,
    );
  }
}

class AuthFailure extends Failure {
  AuthFailure({required super.message, super.code, super.stackTrace});

  factory AuthFailure.invalidCredentials() => AuthFailure(
    message: Translation.translate(
      'invalidCredentials',
      languageCode: Translation.activeLanguage,
    ),
  );

  factory AuthFailure.sessionExpired() => AuthFailure(
    message: Translation.translate(
      'sessionExpired',
      languageCode: Translation.activeLanguage,
    ),
  );

  factory AuthFailure.fromCode(int code) {
    switch (code) {
      case 401:
        return AuthFailure.sessionExpired();
      default:
        return AuthFailure(
          message: Translation.translate(
            'authenticationFailed',
            languageCode: Translation.activeLanguage,
          ),
        );
    }
  }
}

class CacheFailure extends Failure {
  CacheFailure({required super.message, super.stackTrace});

  factory CacheFailure.readError() => CacheFailure(
    message: Translation.translate(
      'localStorageError',
      languageCode: Translation.activeLanguage,
    ),
  );
}

class ParsingFailure extends Failure {
  ParsingFailure({required super.message, super.code, super.stackTrace});

  factory ParsingFailure.invalid() => ParsingFailure(
    message: Translation.translate(
      'invalidData',
      languageCode: Translation.activeLanguage,
    ),
  );
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
    : super(
        message: Translation.translate(
          'permissionDenied_$permission',
          languageCode: Translation.activeLanguage,
        ),
      );
}

class RateLimitFailure extends Failure {
  final Duration retryAfter;

  RateLimitFailure(this.retryAfter, {super.stackTrace})
    : super(
        message: Translation.translate(
          'tooManyRequests',
          languageCode: Translation.activeLanguage,
        ),
        code: 429,
      );

  @override
  List<Object?> get props => [...super.props, retryAfter];
}

class UnimplementedFailure extends Failure {
  UnimplementedFailure()
    : super(
        message: Translation.translate(
          'notImplemented',
          languageCode: Translation.activeLanguage,
        ),
      );
}

class UnknownFailure extends Failure {
  UnknownFailure({super.stackTrace})
    : super(
        message: Translation.translate(
          'unknownError',
          languageCode: Translation.activeLanguage,
        ),
      );
}
