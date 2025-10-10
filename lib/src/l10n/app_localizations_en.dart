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

  @override
  String get refresh => 'Refresh';

  @override
  String get try_different_search_or_category =>
      'Try adjusting your search or category filter';

  @override
  String get loading => 'Loading courses...';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get live => 'Live';

  @override
  String get instructor => 'Instructor';

  @override
  String get live_sessions => 'Live Sessions';

  @override
  String get instructor_dashboard => 'Instructor Dashboard';

  @override
  String get add_new_course => 'Add new course';

  @override
  String get my_courses => 'My Courses';

  @override
  String get manage_courses => 'Manage courses';

  @override
  String get analytics => 'Analytics';

  @override
  String get view_statistics => 'View statistics';

  @override
  String get students => 'Students';

  @override
  String get manage_students => 'Manage students';

  @override
  String get search_results => 'Search Results';

  @override
  String get no_results_found => 'No results found';

  @override
  String get try_different_search => 'Try a different search term';

  @override
  String get searching => 'Searching...';

  @override
  String get errInstructorCannotPurchaseOwnCourse =>
      'Instructors cannot purchase their own courses.';

  @override
  String get course_thumbnail => 'Course Thumbnail';

  @override
  String get no_image_selected => 'No image selected';

  @override
  String get upload_image => 'Upload Image';

  @override
  String get uploaded => 'Uploaded';

  @override
  String get uploading => 'Uploading...';

  @override
  String get please_upload_thumbnail => 'Please upload course thumbnail';

  @override
  String get chapters => 'Chapters';

  @override
  String get no_chapters_added => 'No chapters added yet';

  @override
  String get delete_chapter => 'Delete Chapter';

  @override
  String get delete_chapter_confirmation =>
      'Are you sure you want to delete this chapter?';

  @override
  String get delete => 'Delete';

  @override
  String get delete_video => 'Delete Video';

  @override
  String get delete_video_confirmation =>
      'Are you sure you want to delete this video?';

  @override
  String get delete_quiz => 'Delete Quiz';

  @override
  String get delete_quiz_confirmation =>
      'Are you sure you want to delete this quiz?';

  @override
  String get add_quiz => 'Add Quiz';

  @override
  String get quiz_title => 'Quiz Title';

  @override
  String get enter_quiz_title => 'Enter quiz title';

  @override
  String get quiz_description => 'Quiz Description';

  @override
  String get enter_quiz_description => 'Enter quiz description';

  @override
  String get passing_score => 'Passing Score';

  @override
  String get enter_passing_score => 'Enter passing score (e.g., 70)';

  @override
  String get passing_score_required => 'Passing score is required';

  @override
  String get invalid_passing_score => 'Invalid passing score';

  @override
  String get time_limit_minutes => 'Time Limit (Minutes)';

  @override
  String get enter_time_limit => 'Enter time limit in minutes';

  @override
  String get time_limit_required => 'Time limit is required';

  @override
  String get invalid_time_limit => 'Invalid time limit';

  @override
  String get questions => 'Questions';

  @override
  String get no_questions_added => 'No questions added yet';

  @override
  String get add_question => 'Add Question';

  @override
  String get delete_question => 'Delete Question';

  @override
  String get delete_question_confirmation =>
      'Are you sure you want to delete this question?';

  @override
  String get add_at_least_one_question => 'Please add at least one question';

  @override
  String get question => 'Question';

  @override
  String get enter_question => 'Enter your question';

  @override
  String get question_required => 'Question is required';

  @override
  String get options => 'Options';

  @override
  String get option => 'Option';

  @override
  String get option_required => 'Option is required';

  @override
  String get explanation => 'Explanation';

  @override
  String get optional => 'Optional';

  @override
  String get enter_explanation => 'Enter explanation for the correct answer';

  @override
  String get errStorageUnauthorized =>
      'You don\'t have permission to upload files';

  @override
  String get errStorageCanceled => 'Upload was canceled';

  @override
  String get errStorageQuotaExceeded => 'Storage quota exceeded';

  @override
  String get errStorageRetryLimitExceeded =>
      'Upload failed after multiple retries';

  @override
  String get errStorageInvalidChecksum => 'File validation failed';

  @override
  String get errStorageUnknown => 'Upload failed';

  @override
  String get errImageUploadFailed => 'Failed to upload image';

  @override
  String get edit => 'Edit';

  @override
  String get edit_chapter => 'Edit Chapter';

  @override
  String get edit_video => 'Edit Video';

  @override
  String get edit_quiz => 'Edit Quiz';

  @override
  String get edit_question => 'Edit Question';

  @override
  String get video_order_info =>
      'Videos will be played in ascending order based on this index.';

  @override
  String get my_learning => 'My Learning';

  @override
  String get no_courses_enrolled => 'No Courses Yet';

  @override
  String get browse_and_enroll_courses =>
      'Browse and enroll in courses to start your learning journey!';

  @override
  String get browse_courses => 'Browse Courses';

  @override
  String get continue_learning => 'Continue';

  @override
  String get progress => 'Progress';

  @override
  String get failed_to_load_courses => 'Failed to load courses';

  @override
  String get course => 'Course';

  @override
  String get video => 'Video';

  @override
  String get select_content_to_start => 'Select content to start learning';

  @override
  String get choose_video_or_quiz_from_sidebar =>
      'Choose a video or quiz from the sidebar to begin';

  @override
  String get video_player_placeholder => 'Video Player (Coming Soon)';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get minutes => 'minutes';

  @override
  String get to_pass => 'to pass';

  @override
  String get quiz_functionality_coming_soon => 'Quiz functionality coming soon';

  @override
  String get start_quiz => 'Start Quiz';

  @override
  String get questions_preview => 'Questions Preview';

  @override
  String get owned => 'Owned';

  @override
  String get start_learning => 'Start Learning';

  @override
  String get preview => 'Preview';

  @override
  String get playback_settings => 'Playback Settings';

  @override
  String get captions => 'Captions';

  @override
  String get show_subtitles => 'Show video subtitles';

  @override
  String get toggle_captions => 'Toggle Captions';

  @override
  String get autoplay_next => 'Autoplay Next';

  @override
  String get automatically_play_next_video => 'Automatically play next video';

  @override
  String get playback_speed => 'Playback Speed';

  @override
  String get now_playing => 'Now Playing';

  @override
  String get currently_playing => 'Currently playing';

  @override
  String get no_quizzes_available => 'No quizzes available';

  @override
  String get lessons => 'lessons';

  @override
  String get course_price => 'Course Price';

  @override
  String get special_offer => 'Special Offer';

  @override
  String get limited_time => 'Limited Time';

  @override
  String get what_you_will_learn => 'What You\'ll Learn';

  @override
  String get reviews => 'reviews';

  @override
  String get congratulations => 'Congratulations!';

  @override
  String get course_trailer => 'Course Trailer';

  @override
  String get student_reviews => 'Student Reviews';

  @override
  String get view_all => 'View All';

  @override
  String get enrolled_successfully => 'Enrolled successfully!';

  @override
  String get enroll_free => 'Enroll for Free';

  @override
  String get processing => 'Processing...';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get please_login => 'Please log in to enroll in this course';

  @override
  String get free_course => 'Free Course';
}
