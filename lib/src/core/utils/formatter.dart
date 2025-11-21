import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class Formatter {
  Formatter._();

  static String formatIqd(double value, {AppLocalizations? localization}) {
    final intValue = value.toInt();

    final formatter = NumberFormat('#,###', localization?.localeName ?? 'en');
    final formattedNumber = formatter.format(intValue);

    return '$formattedNumber IQD';
  }

  static String formatCurrency(
    double value,
    String currencyCode, {
    AppLocalizations? localization,
  }) {
    final formatter = NumberFormat.currency(
      locale: localization?.localeName ?? 'en',
      symbol: _getCurrencySymbol(currencyCode),
      decimalDigits: _shouldShowDecimals(currencyCode) ? 2 : 0,
    );
    return formatter.format(value);
  }

  static String formatRelativeDate(
    DateTime date,
    AppLocalizations localization,
  ) {
    final now = DateTime.now();
    final difference = now.difference(date);

    // Today
    if (difference.inDays == 0) {
      if (difference.inHours < 1) {
        return localization.just_now ?? 'Just now';
      } else if (difference.inHours == 1) {
        return localization.hour_ago ?? '1 hour ago';
      } else {
        return '${difference.inHours} ${localization.hours_ago ?? 'hours ago'}';
      }
    }

    if (difference.inDays == 1) {
      return localization.yesterday ?? 'Yesterday';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} ${localization.days_ago ?? 'days ago'}';
    }

    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1
          ? localization.week_ago ?? '1 week ago'
          : '$weeks ${localization.weeks_ago ?? 'weeks ago'}';
    }

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return months == 1
          ? localization.month_ago ?? '1 month ago'
          : '$months ${localization.months_ago ?? 'months ago'}';
    }

    final years = (difference.inDays / 365).floor();
    return years == 1
        ? localization.year_ago ?? '1 year ago'
        : '$years ${localization.years_ago ?? 'years ago'}';
  }

  static String formatDate(DateTime date, {AppLocalizations? localization}) {
    final formatter = DateFormat.yMMMd(localization?.localeName ?? 'en');
    return formatter.format(date);
  }

  static String formatDateTime(
    DateTime dateTime, {
    required BuildContext context,
    AppLocalizations? localization,
  }) {
    final formatter = DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).add_jm();
    return formatter.format(dateTime);
  }

  static String formatTime(DateTime time, {AppLocalizations? localization}) {
    final formatter = DateFormat.jm(localization?.localeName ?? 'en');
    return formatter.format(time);
  }

  static String formatNumber(
    num value, {
    AppLocalizations? localization,
    int? decimalDigits,
  }) {
    final formatter = NumberFormat(
      decimalDigits != null ? '#,##0.${'0' * decimalDigits}' : '#,###',
      localization?.localeName ?? 'en',
    );
    return formatter.format(value);
  }

  static String formatFileSize(int bytes, {AppLocalizations? localization}) {
    if (bytes < 1024) {
      return '$bytes ${localization?.bytes ?? 'B'}';
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} ${localization?.kilobytes ?? 'KB'}';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} ${localization?.megabytes ?? 'MB'}';
    } else {
      final gb = bytes / (1024 * 1024 * 1024);
      return '${gb.toStringAsFixed(1)} ${localization?.gigabytes ?? 'GB'}';
    }
  }

  static String formatPercentage(
    double value, {
    AppLocalizations? localization,
    int decimalDigits = 1,
  }) {
    final formatter = NumberFormat.percentPattern(
      localization?.localeName ?? 'en',
    );
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(value);
  }

  static String formatDuration(
    Duration duration, {
    AppLocalizations? localization,
  }) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours${localization?.hours_short ?? 'h'} $minutes${localization?.minutes_short ?? 'm'}';
    } else if (minutes > 0) {
      return '$minutes${localization?.minutes_short ?? 'm'} $seconds${localization?.seconds_short ?? 's'}';
    } else {
      return '$seconds${localization?.seconds_short ?? 's'}';
    }
  }

  static String _getCurrencySymbol(String currencyCode) {
    final symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'IQD': 'IQD',
      'SAR': 'SAR',
      'AED': 'AED',
      'KWD': 'KWD',
    };
    return symbols[currencyCode.toUpperCase()] ?? currencyCode;
  }

  static bool _shouldShowDecimals(String currencyCode) {
    final noDecimalCurrencies = {'IQD', 'JPY', 'KRW'};
    return !noDecimalCurrencies.contains(currencyCode.toUpperCase());
  }

  static String formatConferenceTime(
    DateTime? actualStartTime,
    DateTime scheduledStartTime,
    bool isLive,
    bool hasEnded,
    AppLocalizations localization,
  ) {
    if (isLive && actualStartTime != null) {
      return _formatElapsedTime(actualStartTime, localization);
    } else if (!hasEnded) {
      return _formatScheduledTime(scheduledStartTime, localization);
    }
    return localization.conferenceEnded;
  }

  static String _formatElapsedTime(
    DateTime startTime,
    AppLocalizations localization,
  ) {
    final elapsed = DateTime.now().difference(startTime);

    if (elapsed.isNegative) {
      return localization.startedAgo('0m');
    }

    if (elapsed.inMinutes < 60) {
      return localization.startedAgo('${elapsed.inMinutes}m');
    }

    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes % 60;

    return localization.startedAgo('${hours}h ${minutes}m');
  }

  static String _formatScheduledTime(
    DateTime scheduledTime,
    AppLocalizations localization,
  ) {
    final timeUntil = scheduledTime.difference(DateTime.now());
    if (timeUntil.inHours < 24) {
      final hours = timeUntil.inHours;
      final minutes = timeUntil.inMinutes % 60;
      return '${localization.startsIn} ${hours}h ${minutes}m';
    } else {
      return DateFormat('MMM dd, HH:mm').format(scheduledTime);
    }
  }

  static int calculateRemainingJoinMinutes(DateTime? actualStartTime) {
    if (actualStartTime == null) return 0;

    final elapsed = DateTime.now().difference(actualStartTime);
    final remainingMinutes = 10 - elapsed.inMinutes;
    return remainingMinutes > 0 ? remainingMinutes : 0;
  }

  static String formatParticipants(
    int current,
    int max,
    AppLocalizations localization,
  ) {
    return '$current/$max';
  }
}
