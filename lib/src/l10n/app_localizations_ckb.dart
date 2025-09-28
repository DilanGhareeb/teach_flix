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

  @override
  String get my_account => 'هەژماری من';

  @override
  String get settings => 'ڕێکخستن';

  @override
  String get dark_mode => 'مۆدی تاریک';

  @override
  String get light_mode => 'مۆدی ڕوناک';

  @override
  String get language => 'زمان';

  @override
  String get select_language => 'زمان هەڵبژێرە';

  @override
  String get english => 'ئینگلیزی';

  @override
  String get kurdish => 'کوردی';

  @override
  String app_version(Object version) {
    return 'وەشانی بەرنامە: $version';
  }

  @override
  String get anonymous => 'نەناسراو';

  @override
  String get no_email => 'ئیمەیل نییە';

  @override
  String get account => 'هەژمار';

  @override
  String get change_password => 'گۆڕینی وشەی نهێنی';

  @override
  String get activity => 'چالاکی';

  @override
  String get security => 'پاراستن';

  @override
  String get appearance => 'ڕووکار';

  @override
  String get logout => 'چوونەدەرەوە';

  @override
  String get edit_profile => 'دەستکاری پرۆفایل';

  @override
  String get welcomeBack => 'بەخێربێیتەوە';

  @override
  String get fillYourDetails => 'تکایە زانیارییەکان پڕبکەرەوە';

  @override
  String get gallery => 'گەلێری';

  @override
  String get camera => 'کامێرا';

  @override
  String get remove_photo => 'وەسفێکی وەسفە بکە';

  @override
  String get save => 'پاشەکەوتکردن';

  @override
  String get cancel => 'هەڵوەشاندنەوە';

  @override
  String get profile_updated => 'پرۆفایل نوێکرایەوە';

  @override
  String get name_hint => 'ناو بنوسە';

  @override
  String get name_required => 'ناو پێویستە';

  @override
  String get name_too_short => 'ناو زۆر کورتە';

  @override
  String get save_changes => 'گۆڕانکارییەکان پاشەکەوت بکە';

  @override
  String get courses => 'کۆرسەکان';

  @override
  String get search_courses => 'گەڕان بە ناو کۆرسەکان';

  @override
  String get balance => 'بالانس';

  @override
  String get apply_teacher => 'داواکاری بوون بە مامۆستا';

  @override
  String get please_upload_id => 'تکایە ناسنامەکەت دابنێ';

  @override
  String get application_submitted => 'داواکارییەکە نێردرا';

  @override
  String get select_category => 'پۆلێک هەڵبژێرە';

  @override
  String get field_required => 'ئەم خانەیە پێویسته';

  @override
  String get tap_to_upload => 'بۆ ناردن کرتە بکە';

  @override
  String get submit_application => 'داواکاری بنێرە';

  @override
  String get upload_teacher_id => 'ناسنامەی مامۆستا دابنێ';

  @override
  String get errInsufficientBalance => 'باڵانسەکەت بەشی کڕینی ئەم کۆرسە ناکات';

  @override
  String get errAlreadyEnrolled => 'تۆ پێشتر لەم کۆرسە داخڵبوویت';
}
