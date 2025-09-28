// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get home => 'Home';

  @override
  String get likes => 'Likes';

  @override
  String get search => 'Search';

  @override
  String get profile => 'Profile';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get login => 'Login';

  @override
  String get createAccount => 'Create account';

  @override
  String get gender => 'Gender';

  @override
  String get unspecified => 'Unspecified';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get noAccount => 'No account?';

  @override
  String get errInvalidEmail => 'Invalid email address';

  @override
  String get errUserDisabled => 'This account has been disabled';

  @override
  String get errInvalidCredentials => 'Email or password is incorrect';

  @override
  String get errTooManyRequests => 'Too many attempts. Please try again later.';

  @override
  String get errSessionExpired => 'Session expired. Please sign in again.';

  @override
  String get errNetwork => 'No internet connection. Please check your network.';

  @override
  String get errOpNotAllowed => 'Email/password sign-in is not enabled.';

  @override
  String get errAuthUnknown => 'Authentication failed. Please try again.';

  @override
  String get errFsPermissionDenied =>
      'You don’t have permission to access this data.';

  @override
  String get errFsUnavailable => 'Service unavailable. Check your connection.';

  @override
  String get errFsNotFound => 'Requested data was not found.';

  @override
  String get errFsUnknown => 'A database error occurred.';

  @override
  String get errServerGeneric => 'A server error occurred. Please try again.';

  @override
  String get errUnknown => 'Something went wrong. Please try again.';

  @override
  String get errFieldRequired => 'This field is required';

  @override
  String get errNameTooShort => 'Name is too short';

  @override
  String errPasswordTooShort(Object min) {
    return 'Password must be at least $min characters';
  }

  @override
  String get my_account => 'My Account';

  @override
  String get settings => 'Settings';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get light_mode => 'Light Mode';

  @override
  String get language => 'Language';

  @override
  String get select_language => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get kurdish => 'Kurdish';

  @override
  String app_version(Object version) {
    return 'App Version: $version';
  }

  @override
  String get anonymous => 'Anonymous';

  @override
  String get no_email => 'No email';

  @override
  String get account => 'Account & Security';

  @override
  String get change_password => 'Change Password';

  @override
  String get activity => 'Activity';

  @override
  String get security => 'Security';

  @override
  String get appearance => 'Appearance';

  @override
  String get logout => 'Logout';

  @override
  String get edit_profile => 'Edit Profile';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get fillYourDetails => 'Please fill in your details';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

  @override
  String get remove_photo => 'Remove Photo';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get profile_updated => 'Profile updated';

  @override
  String get name_hint => 'Name';

  @override
  String get name_required => 'Name is required';

  @override
  String get name_too_short => 'Name is too short';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get courses => 'Courses';

  @override
  String get search_courses => 'Search courses';

  @override
  String get balance => 'Balance';

  @override
  String get apply_teacher => 'Apply to become a Teacher';

  @override
  String get please_upload_id => 'Please upload a valid ID';

  @override
  String get application_submitted => 'Application submitted';

  @override
  String get select_category => 'Select a category';

  @override
  String get field_required => 'This field is required';

  @override
  String get tap_to_upload => 'Tap to upload';

  @override
  String get submit_application => 'Submit Application';

  @override
  String get upload_teacher_id => 'Upload Teacher ID';

  @override
  String get errInsufficientBalance =>
      'You do not have enough balance to purchase this course.';

  @override
  String get errAlreadyEnrolled => 'You are already enrolled in this course.';

  @override
  String get enrolled => 'Enrolled';

  @override
  String get enroll_now => 'Enroll Now';

  @override
  String get course_details => 'Course Details';

  @override
  String get course_content => 'Course Content';

  @override
  String get no_content_available => 'No content available';

  @override
  String get create_course => 'Create Course';

  @override
  String get course_title => 'Course Title';

  @override
  String get enter_course_title => 'Enter course title';

  @override
  String get title_required => 'Title is required';

  @override
  String get description_required => 'Description is required';

  @override
  String get price_required => 'Price is required';

  @override
  String get invalid_price => 'Invalid price';

  @override
  String get course_image_url => 'Course Image URL';

  @override
  String get preview_video_url => 'Preview Video URL';

  @override
  String get add_chapter => 'Add Chapter';

  @override
  String get chapter_title => 'Chapter Title';

  @override
  String get videos => 'Videos';

  @override
  String get quizzes => 'Quizzes';

  @override
  String get add_video => 'Add Video';

  @override
  String get video_title => 'Video Title';

  @override
  String get youtube_url => 'YouTube URL';

  @override
  String get duration_minutes => 'Duration (Minutes)';

  @override
  String get order_index => 'Order Index';

  @override
  String get see_all => 'See All';

  @override
  String get no_courses_found => 'No courses found';

  @override
  String get error_loading_courses => 'Error loading courses';

  @override
  String get retry => 'Retry';

  @override
  String get course_purchased_successfully => 'Course purchased successfully';

  @override
  String get preview_video => 'Preview Video';

  @override
  String get preview_functionality_coming_soon =>
      'Preview functionality coming soon';

  @override
  String get close => 'Close';

  @override
  String get course_created_successfully => 'Course created successfully';

  @override
  String get enter_course_description => 'Enter course description';

  @override
  String get category => 'Category';

  @override
  String get price => 'Price';

  @override
  String get enter_price => 'Enter price';

  @override
  String get enter_image_url => 'Enter image URL';

  @override
  String get image_url_required => 'Image URL is required';

  @override
  String get enter_preview_video_url => 'Enter preview video URL';

  @override
  String get preview_video_required => 'Preview video is required';

  @override
  String get enter_chapter_title => 'Enter chapter title';

  @override
  String get no_videos_added => 'No videos added';

  @override
  String get no_quizzes_added => 'No quizzes added';

  @override
  String get add => 'Add';

  @override
  String get enter_video_title => 'Enter video title';

  @override
  String get enter_youtube_url => 'Enter YouTube URL';

  @override
  String get youtube_url_required => 'YouTube URL is required';

  @override
  String get invalid_youtube_url => 'Invalid YouTube URL';

  @override
  String get enter_video_description => 'Enter video description';

  @override
  String get enter_duration_minutes => 'Enter duration in minutes';

  @override
  String get duration_required => 'Duration is required';

  @override
  String get invalid_duration => 'Invalid duration';

  @override
  String get enter_order_index => 'Enter order index';

  @override
  String get order_required => 'Order is required';

  @override
  String get invalid_order => 'Invalid order';

  @override
  String get description => 'Description';

  @override
  String get all_categories => 'All Categories';

  @override
  String get categories => 'Categories';

  @override
  String get featured_courses => 'Featured Courses';

  @override
  String get welcome_back => 'Welcome back';
}
