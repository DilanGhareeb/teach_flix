// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Central Kurdish (`ckb`).
class AppLocalizationsCkb extends AppLocalizations {
  AppLocalizationsCkb([String locale = 'ckb']) : super(locale);

  @override
  String get helloWorld => 'سڵاو جیهان!';

  @override
  String get home => 'ماڵەوە';

  @override
  String get likes => 'بەدڵبووەکان';

  @override
  String get search => 'گەڕان';

  @override
  String get profile => 'پرۆفایل';

  @override
  String get register => 'تۆمارکردن';

  @override
  String get email => 'ئیمەیل';

  @override
  String get password => 'وشەی نهێنی';

  @override
  String get name => 'ناو';

  @override
  String get login => 'چوونەژوورەوە';

  @override
  String get createAccount => 'دروستکردنی هەژمار';

  @override
  String get gender => 'ڕەگەز';

  @override
  String get unspecified => 'دیارینەکراو';

  @override
  String get male => 'نێر';

  @override
  String get female => 'مێ';

  @override
  String get noAccount => 'هەژمارت نیە؟';

  @override
  String get errInvalidEmail => 'ئیمەیلی نادروستە';

  @override
  String get errUserDisabled => 'ئەم هەژمارە ناچالاککراوە';

  @override
  String get errInvalidCredentials => 'ئیمەیل یان وشەی نهێنی هەڵەیە';

  @override
  String get errTooManyRequests =>
      'هەوڵی زۆرت دا. تکایە دووبارە هەوڵبدە پاش ماوەیەک.';

  @override
  String get errSessionExpired =>
      'کاتەکە تەواو بوو. تکایە دووبارە بچۆ ژوورەوە.';

  @override
  String get errNetwork => 'هیچ پەیوەندیدا نییە. تکایە تۆڕەکەت بپشکنە.';

  @override
  String get errOpNotAllowed =>
      'چوونەژوورەوە بە ئیمەیل/وشەی نهێنی چالاک نەکراوە.';

  @override
  String get errAuthUnknown =>
      'هەڵەیەک ڕوویدا لە کاتی چوونەژوورەوەدا. تکایە دووبارە هەوڵبدە.';

  @override
  String get errFsPermissionDenied =>
      'دەسەڵاتت نییە بۆ دەستگەیشتن بە زانیاریەکان.';

  @override
  String get errFsUnavailable =>
      'خزمەتگوزاریەکە بەردەست نییە. تکایە پەیوەندیدا بپشکنە.';

  @override
  String get errFsNotFound => 'زانیاریە داواکراوەکان نەدۆزرایەوە.';

  @override
  String get errFsUnknown => 'هەڵەیەک ڕوویدا لە داتابەیسەکەدا.';

  @override
  String get errServerGeneric =>
      'هەڵەیەک لە ڕاژەکەدا ڕوویدا. تکایە دووبارە هەوڵبدە.';

  @override
  String get errUnknown => 'هەڵەیەکی نەزانراو ڕوویدا. تکایە دووبارە هەوڵبدە.';

  @override
  String get errFieldRequired => 'ئەم خانەیە پێویسته';

  @override
  String get errNameTooShort => 'ناوەکە زۆر کورتە';

  @override
  String errPasswordTooShort(Object min) {
    return 'وشەی نهێنی دەبێت لانی کەم $min تیپ بێت';
  }
}
