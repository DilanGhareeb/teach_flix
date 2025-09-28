import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ckb.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ckb'),
    Locale('en'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Likes page title
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// Search page title
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Register page title
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Label for the email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Label for the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label for the name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Login page title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Button text for creating a new account
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// Label for the gender input field
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// Unspecified gender
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unspecified;

  /// Male gender
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// Female gender
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// Prompt for users who do not have an account
  ///
  /// In en, this message translates to:
  /// **'No account?'**
  String get noAccount;

  /// Error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get errInvalidEmail;

  /// Error message for disabled user account
  ///
  /// In en, this message translates to:
  /// **'This account has been disabled'**
  String get errUserDisabled;

  /// Error message for incorrect email or password
  ///
  /// In en, this message translates to:
  /// **'Email or password is incorrect'**
  String get errInvalidCredentials;

  /// Error message for too many login attempts
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get errTooManyRequests;

  /// Error message for expired authentication session
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please sign in again.'**
  String get errSessionExpired;

  /// Error message for network connectivity issues
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errNetwork;

  /// Error message when email/password sign-in is disabled
  ///
  /// In en, this message translates to:
  /// **'Email/password sign-in is not enabled.'**
  String get errOpNotAllowed;

  /// Generic authentication error message
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get errAuthUnknown;

  /// Error message for permission denied when accessing data
  ///
  /// In en, this message translates to:
  /// **'You don’t have permission to access this data.'**
  String get errFsPermissionDenied;

  /// Error message for service unavailability
  ///
  /// In en, this message translates to:
  /// **'Service unavailable. Check your connection.'**
  String get errFsUnavailable;

  /// Error message for data not found
  ///
  /// In en, this message translates to:
  /// **'Requested data was not found.'**
  String get errFsNotFound;

  /// Generic database error message
  ///
  /// In en, this message translates to:
  /// **'A database error occurred.'**
  String get errFsUnknown;

  /// Generic server error message
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again.'**
  String get errServerGeneric;

  /// Generic unknown error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errUnknown;

  /// Error message for required form fields
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get errFieldRequired;

  /// Error message for name being too short
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get errNameTooShort;

  /// Error message for password being too short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {min} characters'**
  String errPasswordTooShort(Object min);

  /// Label for the user's account section
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get my_account;

  /// Settings page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Label for the dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// Label for the light mode toggle
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// Label for the language selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Prompt to select a language
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// English language option
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Kurdish language option
  ///
  /// In en, this message translates to:
  /// **'Kurdish'**
  String get kurdish;

  /// Label displaying the app version
  ///
  /// In en, this message translates to:
  /// **'App Version: {version}'**
  String app_version(Object version);

  /// Label for anonymous user
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// Label when no email is available
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get no_email;

  /// Section title for account and security settings
  ///
  /// In en, this message translates to:
  /// **'Account & Security'**
  String get account;

  /// Label for the change password option
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// Label for the activity option
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// Label for the security option
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// Label for the appearance option
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// Label for the logout option
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Label for the edit profile option
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// Greeting for returning users
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Prompt for filling in user details
  ///
  /// In en, this message translates to:
  /// **'Please fill in your details'**
  String get fillYourDetails;

  /// Label for the gallery option
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// Label for the camera option
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// Label for removing a photo
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get remove_photo;

  /// Label for saving changes
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Label for canceling changes
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Success message for profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profile_updated;

  /// Hint for the name input field
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name_hint;

  /// Error message for required name
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get name_required;

  /// Error message for too short name
  ///
  /// In en, this message translates to:
  /// **'Name is too short'**
  String get name_too_short;

  /// Label for saving changes
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// Label for the courses section
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// Placeholder text for searching courses
  ///
  /// In en, this message translates to:
  /// **'Search courses'**
  String get search_courses;

  /// Label displaying the user's balance
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// Label for applying to become a teacher
  ///
  /// In en, this message translates to:
  /// **'Apply to become a Teacher'**
  String get apply_teacher;

  /// Prompt to upload a valid identification document
  ///
  /// In en, this message translates to:
  /// **'Please upload a valid ID'**
  String get please_upload_id;

  /// Success message for submitting an application
  ///
  /// In en, this message translates to:
  /// **'Application submitted'**
  String get application_submitted;

  /// Prompt to select a category
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get select_category;

  /// Error message for required form fields
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get field_required;

  /// Prompt to tap to upload a file
  ///
  /// In en, this message translates to:
  /// **'Tap to upload'**
  String get tap_to_upload;

  /// Label for submitting an application
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submit_application;

  /// Label for uploading a teacher identification document
  ///
  /// In en, this message translates to:
  /// **'Upload Teacher ID'**
  String get upload_teacher_id;

  /// Error message for insufficient balance when purchasing a course
  ///
  /// In en, this message translates to:
  /// **'You do not have enough balance to purchase this course.'**
  String get errInsufficientBalance;

  /// Error message for already being enrolled in a course
  ///
  /// In en, this message translates to:
  /// **'You are already enrolled in this course.'**
  String get errAlreadyEnrolled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ckb', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ckb':
      return AppLocalizationsCkb();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
