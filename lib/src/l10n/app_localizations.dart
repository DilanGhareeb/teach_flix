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

  /// Label indicating the user is enrolled in a course
  ///
  /// In en, this message translates to:
  /// **'Enrolled'**
  String get enrolled;

  /// Call to action for enrolling in a course
  ///
  /// In en, this message translates to:
  /// **'Enroll Now'**
  String get enroll_now;

  /// Title for the course details page
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get course_details;

  /// Label for the course content section
  ///
  /// In en, this message translates to:
  /// **'Course Content'**
  String get course_content;

  /// Message indicating no content is available
  ///
  /// In en, this message translates to:
  /// **'No content available'**
  String get no_content_available;

  /// Title for the create course page
  ///
  /// In en, this message translates to:
  /// **'Create Course'**
  String get create_course;

  /// Label for the course title input field
  ///
  /// In en, this message translates to:
  /// **'Course Title'**
  String get course_title;

  /// Placeholder text for entering a course title
  ///
  /// In en, this message translates to:
  /// **'Enter course title'**
  String get enter_course_title;

  /// Error message for required course title
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get title_required;

  /// Error message for required course description
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get description_required;

  /// Error message for required course price
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get price_required;

  /// Error message for invalid course price
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get invalid_price;

  /// Label for the course image URL input field
  ///
  /// In en, this message translates to:
  /// **'Course Image URL'**
  String get course_image_url;

  /// Label for the preview video URL input field
  ///
  /// In en, this message translates to:
  /// **'Preview Video URL'**
  String get preview_video_url;

  /// Button text for adding a new chapter
  ///
  /// In en, this message translates to:
  /// **'Add Chapter'**
  String get add_chapter;

  /// Label for the chapter title input field
  ///
  /// In en, this message translates to:
  /// **'Chapter Title'**
  String get chapter_title;

  /// Label for the videos section
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// Label for the quizzes section
  ///
  /// In en, this message translates to:
  /// **'Quizzes'**
  String get quizzes;

  /// Button text for adding a new video
  ///
  /// In en, this message translates to:
  /// **'Add Video'**
  String get add_video;

  /// Label for the video title input field
  ///
  /// In en, this message translates to:
  /// **'Video Title'**
  String get video_title;

  /// Label for the YouTube URL input field
  ///
  /// In en, this message translates to:
  /// **'YouTube URL'**
  String get youtube_url;

  /// Label for the video duration input field in minutes
  ///
  /// In en, this message translates to:
  /// **'Duration (Minutes)'**
  String get duration_minutes;

  /// Label for the order index input field
  ///
  /// In en, this message translates to:
  /// **'Order Index'**
  String get order_index;

  /// Button text for seeing all items in a list
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get see_all;

  /// Message indicating no courses were found
  ///
  /// In en, this message translates to:
  /// **'No courses found'**
  String get no_courses_found;

  /// Error message for failing to load courses
  ///
  /// In en, this message translates to:
  /// **'Error loading courses'**
  String get error_loading_courses;

  /// Button text for retrying an action
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Success message for purchasing a course
  ///
  /// In en, this message translates to:
  /// **'Course purchased successfully'**
  String get course_purchased_successfully;

  /// Label for the preview video section
  ///
  /// In en, this message translates to:
  /// **'Preview Video'**
  String get preview_video;

  /// Message indicating that preview functionality is coming soon
  ///
  /// In en, this message translates to:
  /// **'Preview functionality coming soon'**
  String get preview_functionality_coming_soon;

  /// Button text for closing a dialog or screen
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Success message for creating a course
  ///
  /// In en, this message translates to:
  /// **'Course created successfully'**
  String get course_created_successfully;

  /// Placeholder text for entering a course description
  ///
  /// In en, this message translates to:
  /// **'Enter course description'**
  String get enter_course_description;

  /// Label for the course category input field
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Label for the course price input field
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Placeholder text for entering a course price
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get enter_price;

  /// Placeholder text for entering an image URL
  ///
  /// In en, this message translates to:
  /// **'Enter image URL'**
  String get enter_image_url;

  /// Error message for required image URL
  ///
  /// In en, this message translates to:
  /// **'Image URL is required'**
  String get image_url_required;

  /// Placeholder text for entering a preview video URL
  ///
  /// In en, this message translates to:
  /// **'Enter preview video URL'**
  String get enter_preview_video_url;

  /// Error message for required preview video
  ///
  /// In en, this message translates to:
  /// **'Preview video is required'**
  String get preview_video_required;

  /// Placeholder text for entering a chapter title
  ///
  /// In en, this message translates to:
  /// **'Enter chapter title'**
  String get enter_chapter_title;

  /// Message indicating no videos have been added
  ///
  /// In en, this message translates to:
  /// **'No videos added'**
  String get no_videos_added;

  /// Message indicating no quizzes have been added
  ///
  /// In en, this message translates to:
  /// **'No quizzes added'**
  String get no_quizzes_added;

  /// Button text for adding an item
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Placeholder text for entering a video title
  ///
  /// In en, this message translates to:
  /// **'Enter video title'**
  String get enter_video_title;

  /// Placeholder text for entering a YouTube URL
  ///
  /// In en, this message translates to:
  /// **'Enter YouTube URL'**
  String get enter_youtube_url;

  /// Error message for required YouTube URL
  ///
  /// In en, this message translates to:
  /// **'YouTube URL is required'**
  String get youtube_url_required;

  /// Error message for invalid YouTube URL
  ///
  /// In en, this message translates to:
  /// **'Invalid YouTube URL'**
  String get invalid_youtube_url;

  /// Placeholder text for entering a video description
  ///
  /// In en, this message translates to:
  /// **'Enter video description'**
  String get enter_video_description;

  /// Placeholder text for entering video duration in minutes
  ///
  /// In en, this message translates to:
  /// **'Enter duration in minutes'**
  String get enter_duration_minutes;

  /// Error message for required video duration
  ///
  /// In en, this message translates to:
  /// **'Duration is required'**
  String get duration_required;

  /// Error message for invalid video duration
  ///
  /// In en, this message translates to:
  /// **'Invalid duration'**
  String get invalid_duration;

  /// Placeholder text for entering an order index
  ///
  /// In en, this message translates to:
  /// **'Enter order index'**
  String get enter_order_index;

  /// Error message for required order index
  ///
  /// In en, this message translates to:
  /// **'Order is required'**
  String get order_required;

  /// Error message for invalid order index
  ///
  /// In en, this message translates to:
  /// **'Invalid order'**
  String get invalid_order;

  /// Label for the course description input field
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for the all categories option
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get all_categories;

  /// Label for the categories section
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Label for the featured courses section
  ///
  /// In en, this message translates to:
  /// **'Featured Courses'**
  String get featured_courses;

  /// Greeting for returning users
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// Button text for refreshing content
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Suggestion to adjust search or category filter when no results are found
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or category filter'**
  String get try_different_search_or_category;

  /// Message indicating that courses are being loaded
  ///
  /// In en, this message translates to:
  /// **'Loading courses...'**
  String get loading;

  /// Label for the dashboard section
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Label for the live section
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// Label for the instructor section
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// Label for the live sessions section
  ///
  /// In en, this message translates to:
  /// **'Live Sessions'**
  String get live_sessions;

  /// Title for the instructor dashboard page
  ///
  /// In en, this message translates to:
  /// **'Instructor Dashboard'**
  String get instructor_dashboard;

  /// Button text for adding a new course
  ///
  /// In en, this message translates to:
  /// **'Add new course'**
  String get add_new_course;

  /// Label for the user's courses section
  ///
  /// In en, this message translates to:
  /// **'My Courses'**
  String get my_courses;

  /// Label for managing courses
  ///
  /// In en, this message translates to:
  /// **'Manage courses'**
  String get manage_courses;

  /// Label for the analytics section
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Button text for viewing statistics
  ///
  /// In en, this message translates to:
  /// **'View statistics'**
  String get view_statistics;

  /// Label for the students section
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// Label for managing students
  ///
  /// In en, this message translates to:
  /// **'Manage students'**
  String get manage_students;

  /// Title for the search results page
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get search_results;

  /// Message indicating no search results were found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get no_results_found;

  /// Suggestion to try a different search term when no results are found
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get try_different_search;

  /// Message indicating that a search is in progress
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get searching;

  /// Error message when an instructor tries to purchase their own course
  ///
  /// In en, this message translates to:
  /// **'Instructors cannot purchase their own courses.'**
  String get errInstructorCannotPurchaseOwnCourse;

  /// Label for the course thumbnail image section
  ///
  /// In en, this message translates to:
  /// **'Course Thumbnail'**
  String get course_thumbnail;

  /// Message displayed when no thumbnail image has been chosen
  ///
  /// In en, this message translates to:
  /// **'No image selected'**
  String get no_image_selected;

  /// Button text to initiate image upload
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get upload_image;

  /// Status message indicating successful upload completion
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get uploaded;

  /// Status message shown during active file upload process
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// Validation message prompting user to upload a course thumbnail
  ///
  /// In en, this message translates to:
  /// **'Please upload course thumbnail'**
  String get please_upload_thumbnail;

  /// Label for the course chapters section
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// Empty state message when no chapters exist in the course
  ///
  /// In en, this message translates to:
  /// **'No chapters added yet'**
  String get no_chapters_added;

  /// Button text for deleting a chapter
  ///
  /// In en, this message translates to:
  /// **'Delete Chapter'**
  String get delete_chapter;

  /// Confirmation dialog message asking user to confirm chapter deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chapter?'**
  String get delete_chapter_confirmation;

  /// Generic delete action button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Button text for deleting a video
  ///
  /// In en, this message translates to:
  /// **'Delete Video'**
  String get delete_video;

  /// Confirmation dialog message asking user to confirm video deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this video?'**
  String get delete_video_confirmation;

  /// Button text for deleting a quiz
  ///
  /// In en, this message translates to:
  /// **'Delete Quiz'**
  String get delete_quiz;

  /// Confirmation dialog message asking user to confirm quiz deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this quiz?'**
  String get delete_quiz_confirmation;

  /// Button text to add a new quiz to the course
  ///
  /// In en, this message translates to:
  /// **'Add Quiz'**
  String get add_quiz;

  /// Label for the quiz title input field
  ///
  /// In en, this message translates to:
  /// **'Quiz Title'**
  String get quiz_title;

  /// Placeholder text for quiz title input field
  ///
  /// In en, this message translates to:
  /// **'Enter quiz title'**
  String get enter_quiz_title;

  /// Label for the quiz description input field
  ///
  /// In en, this message translates to:
  /// **'Quiz Description'**
  String get quiz_description;

  /// Placeholder text for quiz description input field
  ///
  /// In en, this message translates to:
  /// **'Enter quiz description'**
  String get enter_quiz_description;

  /// Label for the quiz passing score input field
  ///
  /// In en, this message translates to:
  /// **'Passing Score'**
  String get passing_score;

  /// Placeholder text for passing score input field with example
  ///
  /// In en, this message translates to:
  /// **'Enter passing score (e.g., 70)'**
  String get enter_passing_score;

  /// Validation error when passing score field is empty
  ///
  /// In en, this message translates to:
  /// **'Passing score is required'**
  String get passing_score_required;

  /// Validation error when passing score value is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid passing score'**
  String get invalid_passing_score;

  /// Label for the quiz time limit input field
  ///
  /// In en, this message translates to:
  /// **'Time Limit (Minutes)'**
  String get time_limit_minutes;

  /// Placeholder text for time limit input field
  ///
  /// In en, this message translates to:
  /// **'Enter time limit in minutes'**
  String get enter_time_limit;

  /// Validation error when time limit field is empty
  ///
  /// In en, this message translates to:
  /// **'Time limit is required'**
  String get time_limit_required;

  /// Validation error when time limit value is invalid
  ///
  /// In en, this message translates to:
  /// **'Invalid time limit'**
  String get invalid_time_limit;

  /// Label for the quiz questions section
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// Empty state message when no questions exist in the quiz
  ///
  /// In en, this message translates to:
  /// **'No questions added yet'**
  String get no_questions_added;

  /// Button text to add a new question to the quiz
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get add_question;

  /// Button text for deleting a question
  ///
  /// In en, this message translates to:
  /// **'Delete Question'**
  String get delete_question;

  /// Confirmation dialog message asking user to confirm question deletion
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this question?'**
  String get delete_question_confirmation;

  /// Validation error when quiz has no questions
  ///
  /// In en, this message translates to:
  /// **'Please add at least one question'**
  String get add_at_least_one_question;

  /// Label for the question text input field
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// Placeholder text for question input field
  ///
  /// In en, this message translates to:
  /// **'Enter your question'**
  String get enter_question;

  /// Validation error when question field is empty
  ///
  /// In en, this message translates to:
  /// **'Question is required'**
  String get question_required;

  /// Label for the answer options section
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// Label for an individual answer option
  ///
  /// In en, this message translates to:
  /// **'Option'**
  String get option;

  /// Validation error when an option field is empty
  ///
  /// In en, this message translates to:
  /// **'Option is required'**
  String get option_required;

  /// Label for the answer explanation input field
  ///
  /// In en, this message translates to:
  /// **'Explanation'**
  String get explanation;

  /// Indicator text showing that a field is not required
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// Placeholder text for explanation input field
  ///
  /// In en, this message translates to:
  /// **'Enter explanation for the correct answer'**
  String get enter_explanation;

  /// Error message for unauthorized file upload attempt
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to upload files'**
  String get errStorageUnauthorized;

  /// Error message for canceled file upload
  ///
  /// In en, this message translates to:
  /// **'Upload was canceled'**
  String get errStorageCanceled;

  /// Error message for exceeding storage quota
  ///
  /// In en, this message translates to:
  /// **'Storage quota exceeded'**
  String get errStorageQuotaExceeded;

  /// Error message for upload failure after retry attempts
  ///
  /// In en, this message translates to:
  /// **'Upload failed after multiple retries'**
  String get errStorageRetryLimitExceeded;

  /// Error message for file checksum validation failure
  ///
  /// In en, this message translates to:
  /// **'File validation failed'**
  String get errStorageInvalidChecksum;

  /// Generic error message for unknown upload failure
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get errStorageUnknown;

  /// Error message for image upload failure
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image'**
  String get errImageUploadFailed;

  /// Generic edit action button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Button text for editing a chapter
  ///
  /// In en, this message translates to:
  /// **'Edit Chapter'**
  String get edit_chapter;

  /// Button text for editing a video
  ///
  /// In en, this message translates to:
  /// **'Edit Video'**
  String get edit_video;

  /// Button text for editing a quiz
  ///
  /// In en, this message translates to:
  /// **'Edit Quiz'**
  String get edit_quiz;

  /// Button text for editing a question
  ///
  /// In en, this message translates to:
  /// **'Edit Question'**
  String get edit_question;

  /// Information about how video order is determined
  ///
  /// In en, this message translates to:
  /// **'Videos will be played in ascending order based on this index.'**
  String get video_order_info;

  /// Label for the user's learning section
  ///
  /// In en, this message translates to:
  /// **'My Learning'**
  String get my_learning;

  /// Message indicating the user has not enrolled in any courses
  ///
  /// In en, this message translates to:
  /// **'No Courses Yet'**
  String get no_courses_enrolled;

  /// Prompt encouraging users to browse and enroll in courses
  ///
  /// In en, this message translates to:
  /// **'Browse and enroll in courses to start your learning journey!'**
  String get browse_and_enroll_courses;

  /// Button text for browsing available courses
  ///
  /// In en, this message translates to:
  /// **'Browse Courses'**
  String get browse_courses;

  /// Button text for continuing a course
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_learning;

  /// Label for displaying course progress
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// Error message for failing to load courses
  ///
  /// In en, this message translates to:
  /// **'Failed to load courses'**
  String get failed_to_load_courses;

  /// Generic label for a course
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get course;

  /// Generic label for a video
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// Prompt to select course content to begin learning
  ///
  /// In en, this message translates to:
  /// **'Select content to start learning'**
  String get select_content_to_start;

  /// Instruction to select a video or quiz from the sidebar
  ///
  /// In en, this message translates to:
  /// **'Choose a video or quiz from the sidebar to begin'**
  String get choose_video_or_quiz_from_sidebar;

  /// Placeholder text indicating that the video player feature is coming soon
  ///
  /// In en, this message translates to:
  /// **'Video Player (Coming Soon)'**
  String get video_player_placeholder;

  /// Button text for navigating to the previous item
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// Button text for navigating to the next item
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Label for minutes unit of time
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// Label indicating the score needed to pass
  ///
  /// In en, this message translates to:
  /// **'to pass'**
  String get to_pass;

  /// Message indicating that quiz functionality is coming soon
  ///
  /// In en, this message translates to:
  /// **'Quiz functionality coming soon'**
  String get quiz_functionality_coming_soon;

  /// Button text for starting a quiz
  ///
  /// In en, this message translates to:
  /// **'Start Quiz'**
  String get start_quiz;

  /// Label for the questions preview section
  ///
  /// In en, this message translates to:
  /// **'Questions Preview'**
  String get questions_preview;

  /// Label indicating the user owns the course
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get owned;

  /// Button text for starting to learn a course
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get start_learning;

  /// Button text for previewing content
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Label for the playback settings section
  ///
  /// In en, this message translates to:
  /// **'Playback Settings'**
  String get playback_settings;

  /// Label for the captions option
  ///
  /// In en, this message translates to:
  /// **'Captions'**
  String get captions;

  /// Option to enable or disable video subtitles
  ///
  /// In en, this message translates to:
  /// **'Show video subtitles'**
  String get show_subtitles;

  /// Button text for toggling captions on or off
  ///
  /// In en, this message translates to:
  /// **'Toggle Captions'**
  String get toggle_captions;

  /// Label for the autoplay next option
  ///
  /// In en, this message translates to:
  /// **'Autoplay Next'**
  String get autoplay_next;

  /// Option to enable or disable automatic playback of the next video
  ///
  /// In en, this message translates to:
  /// **'Automatically play next video'**
  String get automatically_play_next_video;

  /// Label for the playback speed option
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playback_speed;

  /// Label indicating the currently playing content
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get now_playing;

  /// Label indicating the content that is currently being played
  ///
  /// In en, this message translates to:
  /// **'Currently playing'**
  String get currently_playing;

  /// Message indicating that there are no quizzes available
  ///
  /// In en, this message translates to:
  /// **'No quizzes available'**
  String get no_quizzes_available;

  /// Label for the lessons section
  ///
  /// In en, this message translates to:
  /// **'lessons'**
  String get lessons;

  /// Label for the course price section
  ///
  /// In en, this message translates to:
  /// **'Course Price'**
  String get course_price;

  /// Label for special offer section
  ///
  /// In en, this message translates to:
  /// **'Special Offer'**
  String get special_offer;

  /// Label indicating a limited time offer
  ///
  /// In en, this message translates to:
  /// **'Limited Time'**
  String get limited_time;

  /// Section title for learning outcomes
  ///
  /// In en, this message translates to:
  /// **'What You\'ll Learn'**
  String get what_you_will_learn;

  /// Label for the reviews section
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// Message displayed upon successful completion of a course
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// Label for the course trailer video section
  ///
  /// In en, this message translates to:
  /// **'Course Trailer'**
  String get course_trailer;

  /// Section title for student reviews
  ///
  /// In en, this message translates to:
  /// **'Student Reviews'**
  String get student_reviews;

  /// Button text for viewing all items in a list
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// Success message displayed after enrolling in a course
  ///
  /// In en, this message translates to:
  /// **'Enrolled successfully!'**
  String get enrolled_successfully;

  /// Button text for enrolling in a free course
  ///
  /// In en, this message translates to:
  /// **'Enroll for Free'**
  String get enroll_free;

  /// Status message indicating that an action is being processed
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// Button text for dismissing a message or dialog
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Prompt asking the user to log in before enrolling in a course
  ///
  /// In en, this message translates to:
  /// **'Please log in to enroll in this course'**
  String get please_login;

  /// Label indicating that the course is free
  ///
  /// In en, this message translates to:
  /// **'Free Course'**
  String get free_course;

  /// Label for the deposit action
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get deposit;

  /// Label for the withdraw action
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// Label for the amount input field
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// Label for adding funds to the user's account
  ///
  /// In en, this message translates to:
  /// **'Add funds to your account'**
  String get add_funds_to_account;

  /// Label for withdrawing funds from the user's account
  ///
  /// In en, this message translates to:
  /// **'Withdraw funds from your account'**
  String get withdraw_funds_from_account;

  /// Success message for a successful deposit
  ///
  /// In en, this message translates to:
  /// **'Deposit successful'**
  String get deposit_successful;

  /// Error message for a failed deposit
  ///
  /// In en, this message translates to:
  /// **'Deposit failed'**
  String get deposit_failed;

  /// Success message for a successful withdrawal
  ///
  /// In en, this message translates to:
  /// **'Withdraw successful'**
  String get withdraw_successful;

  /// Error message for a failed withdrawal
  ///
  /// In en, this message translates to:
  /// **'Withdraw failed'**
  String get withdraw_failed;

  /// Error message for invalid amount input
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get invalid_amount;

  /// Error message for insufficient balance
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficient_balance;

  /// Label displaying the user's available balance
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get available_balance;

  /// Label displaying the maximum amount that can be withdrawn
  ///
  /// In en, this message translates to:
  /// **'Maximum withdraw amount'**
  String get max_withdraw_amount;

  /// Placeholder text for entering deposit amount
  ///
  /// In en, this message translates to:
  /// **'Enter amount to deposit'**
  String get enter_amount_to_deposit;

  /// Error message for amount exceeding available balance
  ///
  /// In en, this message translates to:
  /// **'Amount is too large'**
  String get amount_too_large;

  /// Label for quick amount selection
  ///
  /// In en, this message translates to:
  /// **'Quick Amounts'**
  String get quick_amounts;

  /// Button text for selecting the maximum amount
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// Label for changing the profile photo
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get change_photo;

  /// Prompt to select gender
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get select_gender;

  /// Section title for personal information
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// Success message for changing the profile photo
  ///
  /// In en, this message translates to:
  /// **'Photo changed'**
  String get photo_changed;

  /// Warning message for unsaved changes
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes'**
  String get unsaved_changes;

  /// Label for the student role
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// Prompt for instructors to manage their courses and students
  ///
  /// In en, this message translates to:
  /// **'Manage your courses and students'**
  String get manage_your_courses;

  /// Label displaying the total number of courses
  ///
  /// In en, this message translates to:
  /// **'Total Courses'**
  String get total_courses;

  /// Label displaying the total number of students
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get total_students;

  /// Label for quick actions section
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quick_actions;

  /// Label for today's date
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Label for the current month
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get this_month;

  /// Label for the current year
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get this_year;

  /// Label for all time period
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get all_time;

  /// Label displaying the total earnings
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get total_earnings;

  /// Message indicating that there are no courses created yet
  ///
  /// In en, this message translates to:
  /// **'No courses yet'**
  String get no_courses_yet;

  /// Prompt encouraging instructors to create their first course
  ///
  /// In en, this message translates to:
  /// **'Create your first course to get started'**
  String get create_your_first_course;

  /// Message indicating that there are no ratings yet
  ///
  /// In en, this message translates to:
  /// **'No ratings'**
  String get no_ratings;

  /// Message indicating that there are no statistics available yet
  ///
  /// In en, this message translates to:
  /// **'No stats available'**
  String get no_stats_yet;

  /// Button text for retrying an action
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// Generic error message for an unknown error
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknown_error;

  /// Error message for failing to load statistics
  ///
  /// In en, this message translates to:
  /// **'Error Loading Stats'**
  String get error_loading_stats;

  /// Label for yesterday's date
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Label for a number of days ago
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get days_ago;

  /// Label for one day ago
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get day_ago;

  /// Label for one week ago
  ///
  /// In en, this message translates to:
  /// **'week ago'**
  String get week_ago;

  /// Label for a number of weeks ago
  ///
  /// In en, this message translates to:
  /// **'weeks ago'**
  String get weeks_ago;

  /// Label for one month ago
  ///
  /// In en, this message translates to:
  /// **'month ago'**
  String get month_ago;

  /// Label for a number of months ago
  ///
  /// In en, this message translates to:
  /// **'months ago'**
  String get months_ago;

  /// Label for one year ago
  ///
  /// In en, this message translates to:
  /// **'year ago'**
  String get year_ago;

  /// Label for a number of years ago
  ///
  /// In en, this message translates to:
  /// **'years ago'**
  String get years_ago;

  /// Label for the ratings section
  ///
  /// In en, this message translates to:
  /// **'Ratings'**
  String get ratings;

  /// Label for the revenue section
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;
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
