import 'package:flutter/foundation.dart';
import 'package:teach_flix/src/core/errors/failures.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class ErrorLocalizer {
  static String of(Failure f, AppLocalizations localization) {
    if (f is AuthFailure) {
      switch (f.kind) {
        case AuthFailureKind.invalidEmail:
          return localization.errInvalidEmail;
        case AuthFailureKind.userDisabled:
          return localization.errUserDisabled;
        case AuthFailureKind.invalidCredentials:
          return localization.errInvalidCredentials;
        case AuthFailureKind.tooManyRequests:
          return localization.errTooManyRequests;
        case AuthFailureKind.sessionExpired:
          return localization.errSessionExpired;
        case AuthFailureKind.network:
          return localization.errNetwork;
        case AuthFailureKind.operationNotAllowed:
          return localization.errOpNotAllowed;
        case AuthFailureKind.unknown:
          return localization.errAuthUnknown;
      }
    } else if (f is FirestoreFailure) {
      switch (f.kind) {
        case FirestoreFailureKind.permissionDenied:
          return localization.errFsPermissionDenied;
        case FirestoreFailureKind.unavailable:
          return localization.errFsUnavailable;
        case FirestoreFailureKind.notFound:
          return localization.errFsNotFound;
        case FirestoreFailureKind.unknown:
          return localization.errFsUnknown;
      }
    } else if (f is StorageFailure) {
      switch (f.kind) {
        case StorageFailureKind.unauthorized:
          return localization.errStorageUnauthorized;
        case StorageFailureKind.canceled:
          return localization.errStorageCanceled;
        case StorageFailureKind.quotaExceeded:
          return localization.errStorageQuotaExceeded;
        case StorageFailureKind.retryLimitExceeded:
          return localization.errStorageRetryLimitExceeded;
        case StorageFailureKind.invalidChecksum:
          return localization.errStorageInvalidChecksum;
        case StorageFailureKind.unknown:
          return localization.errStorageUnknown;
      }
    } else if (f is ServerFailure) {
      return localization.errServerGeneric;
    } else if (f is UnknownFailure) {
      return localization.errUnknown;
    } else if (f is NotFoundFailure) {
      return localization.errFsNotFound;
    } else if (f is InsufficientBalanceFailure) {
      return localization.errInsufficientBalance;
    } else if (f is AlreadyEnrolledFailure) {
      return localization.errAlreadyEnrolled;
    } else if (f is InstructorCannotPurchaseOwnCourseFailure) {
      return localization.errInstructorCannotPurchaseOwnCourse;
    }
    final base = localization.errUnknown;
    return kDebugMode && f.code != null ? '$base (${f.code})' : base;
  }
}
