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
}
