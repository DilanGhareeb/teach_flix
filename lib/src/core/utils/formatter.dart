import 'package:teach_flix/src/l10n/app_localizations.dart';

class Formatter {
  String formatIqd(double value) {
    final intValue = value.toInt();
    final str = intValue.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      final pos = str.length - i;
      buffer.write(str[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write(',');
    }

    return '${buffer.toString()} IQD';
  }

  String formatDate(DateTime date, AppLocalizations localization) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return localization.today;
    } else if (difference.inDays == 1) {
      return localization.yesterday ?? 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${localization.days_ago ?? "days ago"}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? (localization.week_ago ?? "week ago") : (localization.weeks_ago ?? "weeks ago")}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? (localization.month_ago ?? "month ago") : (localization.months_ago ?? "months ago")}';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? (localization.year_ago ?? "year ago") : (localization.years_ago ?? "years ago")}';
    }
  }
}
