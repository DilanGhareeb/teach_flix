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

  @override
  String get enrolled => 'تۆمارکراو';

  @override
  String get enroll_now => 'ئێستا تۆمار بکە';

  @override
  String get course_details => 'وردەکارییەکانی کۆرس';

  @override
  String get course_content => 'ناوەڕۆکی کۆرس';

  @override
  String get no_content_available => 'هیچ ناوەڕۆکێک بەردەست نییە';

  @override
  String get create_course => 'کۆرس دروست بکە';

  @override
  String get course_title => 'ناونیشانی کۆرس';

  @override
  String get enter_course_title => 'ناونیشانی کۆرس داخڵ بکە';

  @override
  String get title_required => 'ناونیشان پێویستە';

  @override
  String get description_required => 'باسکردن پێویستە';

  @override
  String get price_required => 'نرخ پێویستە';

  @override
  String get invalid_price => 'نرخی نادروست';

  @override
  String get course_image_url => 'بەستەری وێنەی کۆرس';

  @override
  String get preview_video_url => 'بەستەری ڤیدیۆی پێشبینین';

  @override
  String get add_chapter => 'بەش زیاد بکە';

  @override
  String get chapter_title => 'ناونیشانی بەش';

  @override
  String get videos => 'ڤیدیۆکان';

  @override
  String get quizzes => 'تاقیکردنەوەکان';

  @override
  String get add_video => 'ڤیدیۆ زیاد بکە';

  @override
  String get video_title => 'ناونیشانی ڤیدیۆ';

  @override
  String get youtube_url => 'بەستەری یوتیوب';

  @override
  String get duration_minutes => 'ماوە (خولەک)';

  @override
  String get order_index => 'ژمارەی ڕیزبەندی';

  @override
  String get see_all => 'هەموو ببینە';

  @override
  String get no_courses_found => 'هیچ کۆرسێک نەدۆزرایەوە';

  @override
  String get error_loading_courses => 'هەڵە لە بارکردنی کۆرسەکان';

  @override
  String get retry => 'دووبارە هەوڵ بدەوە';

  @override
  String get course_purchased_successfully => 'کۆرس بە سەرکەوتووی کڕدرا';

  @override
  String get preview_video => 'ڤیدیۆی پێشبینین';

  @override
  String get preview_functionality_coming_soon =>
      'تایبەتمەندی پێشبینین بەزووە دێت';

  @override
  String get close => 'دابخە';

  @override
  String get course_created_successfully => 'کۆرس بە سەرکەوتووی دروست کرا';

  @override
  String get enter_course_description => 'باسکردنی کۆرس داخڵ بکە';

  @override
  String get category => 'پۆل';

  @override
  String get price => 'نرخ';

  @override
  String get enter_price => 'نرخ داخڵ بکە';

  @override
  String get enter_image_url => 'بەستەری وێنە داخڵ بکە';

  @override
  String get image_url_required => 'بەستەری وێنە پێویستە';

  @override
  String get enter_preview_video_url => 'بەستەری ڤیدیۆی پێشبینین داخڵ بکە';

  @override
  String get preview_video_required => 'ڤیدیۆی پێشبینین پێویستە';

  @override
  String get enter_chapter_title => 'ناونیشانی بەش داخڵ بکە';

  @override
  String get no_videos_added => 'هیچ ڤیدیۆیەک زیاد نەکراوە';

  @override
  String get no_quizzes_added => 'هیچ تاقیکردنەوەیەک زیاد نەکراوە';

  @override
  String get add => 'زیاد بکە';

  @override
  String get enter_video_title => 'ناونیشانی ڤیدیۆ داخڵ بکە';

  @override
  String get enter_youtube_url => 'بەستەری یوتیوب داخڵ بکە';

  @override
  String get youtube_url_required => 'بەستەری یوتیوب پێویستە';

  @override
  String get invalid_youtube_url => 'بەستەری یوتیوبی نادروست';

  @override
  String get enter_video_description => 'باسکردنی ڤیدیۆ داخڵ بکە';

  @override
  String get enter_duration_minutes => 'ماوە بە خولەک داخڵ بکە';

  @override
  String get duration_required => 'ماوە پێویستە';

  @override
  String get invalid_duration => 'ماوەی نادروست';

  @override
  String get enter_order_index => 'ژمارەی ڕیزبەندی داخڵ بکە';

  @override
  String get order_required => 'ڕیزبەندی پێویستە';

  @override
  String get invalid_order => 'ڕیزبەندی نادروست';

  @override
  String get description => 'باسکردن';

  @override
  String get all_categories => 'هەموو پۆلەکان';

  @override
  String get categories => 'پۆلەکان';

  @override
  String get featured_courses => 'کۆرسە تایبەتەکان';

  @override
  String get welcome_back => 'بەخێربێیتەوە';

  @override
  String get refresh => 'ڕیفرێش';

  @override
  String get try_different_search_or_category =>
      'گەڕان یان پۆلی جیاواز تاقیبکەرەوە';

  @override
  String get loading => 'بارکردنی کۆرسەکان...';

  @override
  String get dashboard => 'داشبۆرد';

  @override
  String get live => 'ڵایڤ';

  @override
  String get instructor => 'مامۆستا';

  @override
  String get live_sessions => 'ڵایڤی ڕاستەوخۆ';

  @override
  String get instructor_dashboard => 'داشبۆردی مامۆستا';

  @override
  String get add_new_course => 'زیادکردنی کۆرسی نوێ';

  @override
  String get my_courses => 'کۆرسەکانم';

  @override
  String get manage_courses => 'بەڕێوەبردنی کۆرسەکان';

  @override
  String get analytics => 'ئانالیتیکس';

  @override
  String get view_statistics => 'بینینی ئامارەکان';

  @override
  String get students => 'خوێندکارەکان';

  @override
  String get manage_students => 'بەڕێوەبردنی خوێندکارەکان';

  @override
  String get search_results => 'ئەنجامی گەڕان';

  @override
  String get no_results_found => 'هیچ ئەنجامێک نەدۆزرایەوە';

  @override
  String get try_different_search => 'گەڕانێکی جیاواز بکە';

  @override
  String get searching => 'دەگەڕێت...';

  @override
  String get errInstructorCannotPurchaseOwnCourse =>
      'مامۆستا ناتوانێت کۆرسی خۆی بکڕێت';

  @override
  String get course_thumbnail => 'وێنۆچکەی کۆرس';

  @override
  String get no_image_selected => 'هیچ وێنەیەک هەڵنەبژێردراوە';

  @override
  String get upload_image => 'بارکردنی وێنە';

  @override
  String get uploaded => 'بارکرا';

  @override
  String get uploading => 'بارکردن...';

  @override
  String get please_upload_thumbnail => 'تکایە وێنۆچکەی کۆرس باربکە';

  @override
  String get chapters => 'بەشەکان';

  @override
  String get no_chapters_added => 'هێشتا هیچ بەشێک زیادنەکراوە';

  @override
  String get delete_chapter => 'سڕینەوەی بەش';

  @override
  String get delete_chapter_confirmation => 'دڵنیایت لە سڕینەوەی ئەم بەشە؟';

  @override
  String get delete => 'سڕینەوە';

  @override
  String get delete_video => 'سڕینەوەی ڤیدیۆ';

  @override
  String get delete_video_confirmation => 'دڵنیایت لە سڕینەوەی ئەم ڤیدیۆیە؟';

  @override
  String get delete_quiz => 'سڕینەوەی تاقیکردنەوە';

  @override
  String get delete_quiz_confirmation =>
      'دڵنیایت لە سڕینەوەی ئەم تاقیکردنەوەیە؟';

  @override
  String get add_quiz => 'زیادکردنی تاقیکردنەوە';

  @override
  String get quiz_title => 'ناونیشانی تاقیکردنەوە';

  @override
  String get enter_quiz_title => 'ناونیشانی تاقیکردنەوە بنووسە';

  @override
  String get quiz_description => 'پێناسەی تاقیکردنەوە';

  @override
  String get enter_quiz_description => 'پێناسەی تاقیکردنەوە بنووسە';

  @override
  String get passing_score => 'نمرەی تێپەڕبوون';

  @override
  String get enter_passing_score => 'نمرەی تێپەڕبوون بنووسە (بۆ نموونە، ٧٠)';

  @override
  String get passing_score_required => 'نمرەی تێپەڕبوون پێویستە';

  @override
  String get invalid_passing_score => 'نمرەی تێپەڕبوون نادروستە';

  @override
  String get time_limit_minutes => 'کاتی دیاریکراو (خولەک)';

  @override
  String get enter_time_limit => 'کاتی دیاریکراو بە خولەک بنووسە';

  @override
  String get time_limit_required => 'کاتی دیاریکراو پێویستە';

  @override
  String get invalid_time_limit => 'کاتی دیاریکراو نادروستە';

  @override
  String get questions => 'پرسیارەکان';

  @override
  String get no_questions_added => 'هێشتا هیچ پرسیارێک زیادنەکراوە';

  @override
  String get add_question => 'زیادکردنی پرسیار';

  @override
  String get delete_question => 'سڕینەوەی پرسیار';

  @override
  String get delete_question_confirmation => 'دڵنیایت لە سڕینەوەی ئەم پرسیارە؟';

  @override
  String get add_at_least_one_question => 'تکایە لانیکەم یەک پرسیار زیاد بکە';

  @override
  String get question => 'پرسیار';

  @override
  String get enter_question => 'پرسیارەکەت بنووسە';

  @override
  String get question_required => 'پرسیار پێویستە';

  @override
  String get options => 'هەڵبژاردەکان';

  @override
  String get option => 'هەڵبژاردە';

  @override
  String get option_required => 'هەڵبژاردە پێویستە';

  @override
  String get explanation => 'ڕوونکردنەوە';

  @override
  String get optional => 'ئیختیاری';

  @override
  String get enter_explanation => 'ڕوونکردنەوە بۆ وەڵامی ڕاست بنووسە';

  @override
  String get errStorageUnauthorized => 'مۆڵەتت نییە بۆ بارکردنی فایل';

  @override
  String get errStorageCanceled => 'بارکردن هەڵوەشێنرایەوە';

  @override
  String get errStorageQuotaExceeded => 'بڕی کۆگای تەواو بووە';

  @override
  String get errStorageRetryLimitExceeded =>
      'بارکردن سەرکەوتوو نەبوو دوای چەند هەوڵێک';

  @override
  String get errStorageInvalidChecksum => 'بارکردنی وێنە سەرکەوتوو نەبوو';

  @override
  String get errStorageUnknown => 'بارکردن سەرکەوتوو نەبوو';

  @override
  String get errImageUploadFailed => 'بارکردنی وێنە سەرکەوتوو نەبوو';

  @override
  String get edit => 'دەستکاری';

  @override
  String get edit_chapter => 'دەستکاری بەش';

  @override
  String get edit_video => 'دەستکاری ڤیدیۆ';

  @override
  String get edit_quiz => 'دەستکاری تاقیکردنەوە';

  @override
  String get edit_question => 'دەستکاری پرسیار';

  @override
  String get video_order_info =>
      'ئەم ژمارەیە دیاریکردنی ڤیدیۆ لە ناو بەشەکە دەکات. ڤیدیۆکان بە شێوەی خوارەوە بەپێی ئەم ژمارەیە ڕیزدەکرێن.';

  @override
  String get my_learning => 'فێربوونەکانم';

  @override
  String get no_courses_enrolled => 'هێشتا هیچ کۆرسێک نییە';

  @override
  String get browse_and_enroll_courses =>
      'بگەڕێ و تۆمار بکە لە کۆرسەکان بۆ دەستپێکردنی گەشتی فێربوونت!';

  @override
  String get browse_courses => 'گەڕان بە کۆرسەکان';

  @override
  String get continue_learning => 'بەردەوامبە';

  @override
  String get progress => 'پێشکەوتن';

  @override
  String get failed_to_load_courses => 'سەرکەوتوو نەبوو لە بارکردنی کۆرسەکان';

  @override
  String get course => 'کۆرس';

  @override
  String get video => 'ڤیدیۆ';

  @override
  String get select_content_to_start =>
      'ناوەڕۆکێک هەڵبژێرە بۆ دەستپێکردنی فێربوون';

  @override
  String get choose_video_or_quiz_from_sidebar =>
      'ڤیدیۆیەک یان تاقیکردنەوەیەک لە لایەنەوە هەڵبژێرە بۆ دەستپێکردن';

  @override
  String get video_player_placeholder => 'لێدەری ڤیدیۆ (بەم زووانە)';

  @override
  String get previous => 'پێشوو';

  @override
  String get next => 'دواتر';

  @override
  String get minutes => 'خولەک';

  @override
  String get to_pass => 'بۆ تێپەڕین';

  @override
  String get quiz_functionality_coming_soon =>
      'تایبەتمەندی تاقیکردنەوە بەم زووانە';

  @override
  String get start_quiz => 'دەستپێکردنی تاقیکردنەوە';

  @override
  String get questions_preview => 'پێشبینینی پرسیارەکان';

  @override
  String get owned => 'خاوەنکراو';

  @override
  String get start_learning => 'دەستپێکردنی فێربوون';

  @override
  String get preview => 'پێشبینین';

  @override
  String get playback_settings => 'ڕێکخستنەکانی لێدان';

  @override
  String get captions => 'ژێرنووس';

  @override
  String get show_subtitles => 'پیشاندانی ژێرنووس';

  @override
  String get toggle_captions => 'گۆڕینی ژێرنووس';

  @override
  String get autoplay_next => 'لێدانی خۆکارانەی دواتر';

  @override
  String get automatically_play_next_video => 'لێدانی خۆکارانەی ڤیدیۆی دواتر';

  @override
  String get playback_speed => 'خێرایی لێدان';

  @override
  String get now_playing => 'ئێستا لێدەدرێت';

  @override
  String get currently_playing => 'ئێستا لێدەدرێت';

  @override
  String get no_quizzes_available => 'هیچ تاقیکردنەوەیەک بەردەست نییە';

  @override
  String get lessons => 'وانەکان';

  @override
  String get course_price => 'نرخی کۆرس: ';

  @override
  String get special_offer => 'ئۆفەری تایبەت';

  @override
  String get limited_time => 'کاتی دیاریکراو';

  @override
  String get what_you_will_learn => 'ئەمەی دەتەوێت فێربیت';

  @override
  String get reviews => 'پيداچوونەکان';

  @override
  String get congratulations => 'پیرۆزە!';

  @override
  String get course_trailer => 'پێشبینینی کۆرس';

  @override
  String get student_reviews => 'پێداچوونەوەکانی قوتابیان';

  @override
  String get view_all => 'بینینی هەمووی';

  @override
  String get enrolled_successfully => 'تۆمارکرا بە سەرکەوتووی';

  @override
  String get enroll_free => 'بەخۆڕایی تۆماربە';

  @override
  String get processing => 'لە پڕۆسەدا...';

  @override
  String get dismiss => 'داخستن';

  @override
  String get please_login => 'تکایە بچۆ ژوورەوە بۆ بەردەوامبوون';

  @override
  String get free_course => 'کۆرسی بەخۆڕایی';

  @override
  String get deposit => 'دانان';

  @override
  String get withdraw => 'دەرهێنان';

  @override
  String get amount => 'بڕ';

  @override
  String get add_funds_to_account => 'زیادکردنی پارە بۆ هەژمارەکەت';

  @override
  String get withdraw_funds_from_account => 'دەرهێنانی پارە لە هەژمارەکەت';

  @override
  String get deposit_successful => 'دانان سەرکەوتوو بوو';

  @override
  String get deposit_failed => 'دانان سەرکەوتوو نەبوو';

  @override
  String get withdraw_successful => 'دەرهێنان سەرکەوتوو بوو';

  @override
  String get withdraw_failed => 'دەرهێنان سەرکەوتوو نەبوو';

  @override
  String get invalid_amount => 'تکایە بڕێکی دروست بنووسە';

  @override
  String get insufficient_balance => 'بالانسەکە بەشی نییە';

  @override
  String get available_balance => 'بالانسی بەردەست';

  @override
  String get max_withdraw_amount => 'زۆرترین بڕی دەرهێنان';

  @override
  String get enter_amount_to_deposit => 'بڕێک بنووسە بۆ دانان';

  @override
  String get amount_too_large => 'بڕەکە زۆر گەورەیە';

  @override
  String get quick_amounts => 'بڕە خێراکان';

  @override
  String get max => 'زۆرترین';

  @override
  String get change_photo => 'گۆڕینی وێنە';

  @override
  String get select_gender => 'هەڵبژاردنی ڕەگەز';

  @override
  String get personal_information => 'زانیاری کەسی';

  @override
  String get photo_changed => 'وێنە گۆڕدرا';

  @override
  String get unsaved_changes => 'گۆڕانکاری پاشەکەوت نەکراوت هەیە';

  @override
  String get student => 'خوێندکار';

  @override
  String get manage_your_courses => 'بەڕێوەبردنی کۆرسەکان و خوێندکارەکانت';

  @override
  String get total_courses => 'کۆی گشتی کۆرسەکان';

  @override
  String get total_students => 'کۆی گشتی خوێندکاران';

  @override
  String get quick_actions => 'کردارە خێراکان';

  @override
  String get today => 'ئەمڕۆ';

  @override
  String get this_month => 'ئەم مانگە';

  @override
  String get this_year => 'ئەمساڵ';

  @override
  String get all_time => 'هەموو کات';

  @override
  String get total_earnings => 'کۆی گشتی داهات';

  @override
  String get no_courses_yet => 'هێشتا هیچ کۆرسێک نییە';

  @override
  String get create_your_first_course =>
      'یەکەم کۆرسەکەت دروست بکە بۆ دەستپێکردن';

  @override
  String get no_ratings => 'هەڵسەنگاندن نییە';

  @override
  String get no_stats_yet => 'ئامار بەردەست نییە';

  @override
  String get try_again => 'هەوڵبدەرەوە';

  @override
  String get unknown_error => 'هەڵەیەکی نەزانراو ڕوویدا';

  @override
  String get error_loading_stats => 'هەڵە لە بارکردنی ئامارەکان';

  @override
  String get yesterday => 'دوێنێ';

  @override
  String get days_ago => 'ڕۆژ لەمەوبەر';

  @override
  String get day_ago => 'ڕۆژێک لەمەوبەر';

  @override
  String get week_ago => 'هەفتەیەک لەمەوبەر';

  @override
  String get weeks_ago => 'هەفتە لەمەوبەر';

  @override
  String get month_ago => 'مانگێک لەمەوبەر';

  @override
  String get months_ago => 'مانگ لەمەوبەر';

  @override
  String get year_ago => 'ساڵێک لەمەوبەر';

  @override
  String get years_ago => 'ساڵ لەمەوبەر';

  @override
  String get ratings => 'هەڵسەنگاندنەکان';

  @override
  String get revenue => 'داهات';

  @override
  String get edit_course => 'دەستکاریکردنی خول';

  @override
  String get course_updated_successfully => 'خولەکە بە سەرکەوتوویی نوێکرایەوە!';

  @override
  String get course_deleted_successfully => 'خولەکە بە سەرکەوتوویی سڕایەوە!';

  @override
  String get update_course => 'نوێکردنەوەی خول';

  @override
  String get delete_course => 'سڕینەوەی خول';

  @override
  String get delete_course_confirmation =>
      'دڵنیایت کە دەتەوێت ئەم خولە بسڕیتەوە؟ ئەم کردارە ناتوانرێت هەڵبوەشێنرێتەوە.';

  @override
  String get become_instructor => 'ببە بە مامۆستا';

  @override
  String get share_your_knowledge => 'زانیاریەکانت لەگەڵ قوتابیان بەشداری بکە';

  @override
  String get upload_both_sides =>
      'تکایە وێنەی ڕوون لە هەردوو لای ناسنامەکەت بار بکە';

  @override
  String get front_id => 'ڕووی پێشەوەی ناسنامە';

  @override
  String get back_id => 'ڕووی پشتەوەی ناسنامە';

  @override
  String get please_upload_both_ids => 'تکایە هەردوو لای ناسنامەکەت بار بکە';

  @override
  String get application_failed => 'داواکاریەکە سەرکەوتوو نەبوو';

  @override
  String get application_review_info =>
      'داواکاریەکەت لە ماوەی ٢-٣ ڕۆژی کاری پێداچوونەوە دەکرێت. کاتێک پەسەند کرا بە ئیمەیڵ ئاگادار دەکرێیتەوە.';

  @override
  String get error => 'هەڵە';

  @override
  String get select_image_source => 'سەرچاوەی وێنە هەڵبژێرە';

  @override
  String get crop_image => 'بڕینی وێنە';

  @override
  String get guest => 'میوان';

  @override
  String get login_to_unlock_features => 'بچۆ ژوورەوە بۆ بەردەوامبوون';

  @override
  String get create_account_message => 'هەژمارت دروست بکە بۆ بەردەوامبوون';

  @override
  String get not_logged_in => 'ئەکاونتت نییە!';

  @override
  String get forget_password => 'وشەی نهێنیت لەبیرچووەتەوە؟';

  @override
  String get password_reset_email_sent =>
      'ئیمەیڵی گەڕانەوەی وشەی نهێنی نێردرا! سەیری ساندووقەکەت بکە.';

  @override
  String get forgot_password => 'وشەی نهێنیت لەبیرچووە؟';

  @override
  String get forgot_password_description =>
      'ناونیشانی ئیمەیڵەکەت بنووسە و بەستەرێکت بۆ دەنێرین بۆ گەڕانەوەی وشەی نهێنی.';

  @override
  String get send_reset_link => 'ناردنی بەستەری گەڕانەوە';

  @override
  String get email_sent => 'ئیمەیڵ نێردرا!';

  @override
  String get check_email_for_reset_link =>
      'بەستەرێکی گەڕانەوەی وشەی نهێنیمان ناردووە بۆ';

  @override
  String get back_to_login => 'گەڕانەوە بۆ چوونەژوورەوە';

  @override
  String get instructor_rules => 'مەرجەکان و یاساکانی مامۆستا';

  @override
  String get rule_quality => 'ناوەڕۆکی کوالیتی بەرز';

  @override
  String get rule_quality_desc =>
      'کۆرسی کوالیتی بەرز و ڕەسەن دروست بکە کە بەهای ڕاستەقینە بۆ قوتابیان دابین بکات.';

  @override
  String get rule_commitment => 'پابەندبوون بە کات';

  @override
  String get rule_commitment_desc =>
      'کاتی پێویست تەرخان بکە بۆ دروستکردن، نوێکردنەوە و پاراستنی کۆرسەکانت بە بەردەوامی.';

  @override
  String get rule_support => 'پشتگیری قوتابیان';

  @override
  String get rule_support_desc =>
      'وەڵامی پرسیارەکانی قوتابیان بدەرەوە و پشتگیریان پێشکەش بکە بە کاتی گونجاو.';

  @override
  String get rule_guidelines => 'پەیڕەوکردنی ڕێنماییەکان';

  @override
  String get rule_guidelines_desc =>
      'پابەند بە بە ڕێنماییەکانی کۆمەڵگا و ستانداردەکانی وانەوتنەوە لە هەموو کاتێکدا.';

  @override
  String get rule_copyright => 'ڕێزگرتن لە مافی لەبەرگرتنەوە';

  @override
  String get rule_copyright_desc =>
      'تەنها ئەو ناوەڕۆکە بەکاربهێنە کە مافی بەکارهێنانیت هەیە و ڕێز لە موڵکی زیهنی بگرە.';

  @override
  String get rule_improvement => 'باشترکردنی بەردەوام';

  @override
  String get rule_improvement_desc =>
      'کۆرسەکانت نوێ بکەرەوە بەپێی فیدباک و لەگەڵ بابەتەکەت بە نوێ بمێنەرەوە.';

  @override
  String get agree_to_terms =>
      'من ڕازیم بە پەیڕەوکردنی هەموو یاسا و مەرجەکانی سەرەوە';

  @override
  String get must_agree_to_terms => 'دەبێت ڕازی بیت بە مەرج و یاساکان';

  @override
  String get ai_assistant_coming_soon => 'زیرەکی دەستکرد بەم زووانە';

  @override
  String get please_login_to_rate => 'تکایە بچۆ ژوورەوە بۆ هەڵسەنگاندن';

  @override
  String get ai_assistant => 'یارمەتی زیرەکی دەستکرد';

  @override
  String get rate_course => 'کۆرسەکە هەڵبسەنگێنە';

  @override
  String get price_cannot_be_negative => 'نرخی کۆرس ناتوانێت نێگەتیڤ بێت';

  @override
  String get confirm_purchase => 'پشتڕاستکردنەوەی کڕین';

  @override
  String get confirm_enroll => 'بەڵێ، تۆمارببە';

  @override
  String get confirm_buy => 'بەڵێ، ئێستا بیکڕە';

  @override
  String get confirm_purchase_message => 'دڵنیای لە کڕینی ئەم کۆرسە؟';

  @override
  String get confirm_enroll_message => 'دڵنیای لە تۆماربوون لەم کۆرسەدا؟';

  @override
  String get total_amount => 'کۆی گشتی';

  @override
  String get not_enrolled_error =>
      'دەبێت لەم خولەدا ناونووس کرابیت بۆ هەڵسەنگاندنی';

  @override
  String get already_rated_error =>
      'تۆ پێشتر ئەم خولەت هەڵسەنگاندووە. دەتوانیت دەستکاری هەڵسەنگاندنی ئێستات بکەیت.';

  @override
  String get invalid_rating_error =>
      'هەڵسەنگاندن دەبێت لە نێوان 1 بۆ 5 ئەستێرە بێت';

  @override
  String get instructor_cannot_rate_error =>
      'ڕاهێنەر ناتوانێت خولەکانی خۆی هەڵبسەنگێنێت';

  @override
  String get edit_rating => 'دەستکاریکردنی هەڵسەنگاندن';

  @override
  String get delete_rating => 'سڕینەوەی هەڵسەنگاندن';

  @override
  String get delete_rating_confirmation =>
      'دڵنیایت لە سڕینەوەی هەڵسەنگاندنەکەت؟';

  @override
  String get comment => 'تێبینی';

  @override
  String get share_your_thoughts =>
      'بیر و بۆچوونەکانت دەربارەی ئەم خولە بنووسە...';

  @override
  String get submit => 'ناردن';

  @override
  String get update => 'نوێکردنەوە';

  @override
  String get poor => 'لاواز';

  @override
  String get fair => 'مامناوەند';

  @override
  String get good => 'باش';

  @override
  String get very_good => 'زۆر باش';

  @override
  String get excellent => 'نایاب';

  @override
  String get rating_added_successfully =>
      'هەڵسەنگاندنەکە بە سەرکەوتوویی زیادکرا!';

  @override
  String get rating_updated_successfully =>
      'هەڵسەنگاندنەکە بە سەرکەوتوویی نوێکرایەوە!';

  @override
  String get rating_deleted_successfully =>
      'هەڵسەنگاندنەکە بە سەرکەوتوویی سڕایەوە!';

  @override
  String get your_rating => 'هەڵسەنگاندنی تۆ';

  @override
  String get coming_soon => 'بەم زووانە!';

  @override
  String get just_now => 'ئێستا';

  @override
  String get no_reviews_yet => 'هێشتا هەڵسەنگاندن نییە';

  @override
  String get top_rated_courses => 'باشترین کۆرسەکەکان';
}
