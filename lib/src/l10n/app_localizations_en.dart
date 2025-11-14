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

  @override
  String get deposit => 'Deposit';

  @override
  String get withdraw => 'Withdraw';

  @override
  String get amount => 'Amount';

  @override
  String get add_funds_to_account => 'Add funds to your account';

  @override
  String get withdraw_funds_from_account => 'Withdraw funds from your account';

  @override
  String get deposit_successful => 'Deposit successful';

  @override
  String get deposit_failed => 'Deposit failed';

  @override
  String get withdraw_successful => 'Withdraw successful';

  @override
  String get withdraw_failed => 'Withdraw failed';

  @override
  String get invalid_amount => 'Please enter a valid amount';

  @override
  String get insufficient_balance => 'Insufficient balance';

  @override
  String get available_balance => 'Available Balance';

  @override
  String get max_withdraw_amount => 'Maximum withdraw amount';

  @override
  String get enter_amount_to_deposit => 'Enter amount to deposit';

  @override
  String get amount_too_large => 'Amount is too large';

  @override
  String get quick_amounts => 'Quick Amounts';

  @override
  String get max => 'Max';

  @override
  String get change_photo => 'Change Photo';

  @override
  String get select_gender => 'Select Gender';

  @override
  String get personal_information => 'Personal Information';

  @override
  String get photo_changed => 'Photo changed';

  @override
  String get unsaved_changes => 'You have unsaved changes';

  @override
  String get student => 'Student';

  @override
  String get manage_your_courses => 'Manage your courses and students';

  @override
  String get total_courses => 'Total Courses';

  @override
  String get total_students => 'Total Students';

  @override
  String get quick_actions => 'Quick Actions';

  @override
  String get today => 'Today';

  @override
  String get this_month => 'This Month';

  @override
  String get this_year => 'This Year';

  @override
  String get all_time => 'All Time';

  @override
  String get total_earnings => 'Total Earnings';

  @override
  String get no_courses_yet => 'No courses yet';

  @override
  String get create_your_first_course =>
      'Create your first course to get started';

  @override
  String get no_ratings => 'No ratings';

  @override
  String get no_stats_yet => 'No stats available';

  @override
  String get try_again => 'Try Again';

  @override
  String get unknown_error => 'Unknown error occurred';

  @override
  String get error_loading_stats => 'Error Loading Stats';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get days_ago => 'days ago';

  @override
  String get day_ago => 'day ago';

  @override
  String get week_ago => 'week ago';

  @override
  String get weeks_ago => 'weeks ago';

  @override
  String get month_ago => 'month ago';

  @override
  String get months_ago => 'months ago';

  @override
  String get year_ago => 'year ago';

  @override
  String get years_ago => 'years ago';

  @override
  String get ratings => 'Ratings';

  @override
  String get revenue => 'Revenue';

  @override
  String get edit_course => 'Edit Course';

  @override
  String get course_updated_successfully => 'Course updated successfully!';

  @override
  String get course_deleted_successfully => 'Course deleted successfully!';

  @override
  String get update_course => 'Update Course';

  @override
  String get delete_course => 'Delete Course';

  @override
  String get delete_course_confirmation =>
      'Are you sure you want to delete this course? This action cannot be undone.';

  @override
  String get become_instructor => 'Become an Instructor';

  @override
  String get share_your_knowledge =>
      'Share your knowledge with students worldwide';

  @override
  String get upload_both_sides =>
      'Please upload clear photos of both sides of your ID';

  @override
  String get front_id => 'Front Side of ID';

  @override
  String get back_id => 'Back Side of ID';

  @override
  String get please_upload_both_ids =>
      'Please upload both front and back of your ID';

  @override
  String get application_failed => 'Application failed';

  @override
  String get application_review_info =>
      'Your application will be reviewed within 2-3 business days. You\'ll be notified via email once approved.';

  @override
  String get error => 'Error';

  @override
  String get select_image_source => 'Select Image Source';

  @override
  String get crop_image => 'Crop Image';

  @override
  String get guest => 'Guest';

  @override
  String get login_to_unlock_features => 'Login to unlock more features';

  @override
  String get create_account_message =>
      'Create an account to track your learning progress and access exclusive content.';

  @override
  String get not_logged_in => 'You are not logged in';

  @override
  String get forget_password => 'Forgot Password?';

  @override
  String get password_reset_email_sent =>
      'Password reset email sent! Check your inbox.';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get forgot_password_description =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get send_reset_link => 'Send Reset Link';

  @override
  String get email_sent => 'Email Sent!';

  @override
  String get check_email_for_reset_link =>
      'We\'ve sent a password reset link to';

  @override
  String get back_to_login => 'Back to Login';

  @override
  String get instructor_rules => 'Instructor Requirements & Rules';

  @override
  String get rule_quality => 'Quality Content';

  @override
  String get rule_quality_desc =>
      'Create high-quality, original courses that provide real value to students.';

  @override
  String get rule_commitment => 'Time Commitment';

  @override
  String get rule_commitment_desc =>
      'Dedicate sufficient time to create, update, and maintain your courses regularly.';

  @override
  String get rule_support => 'Student Support';

  @override
  String get rule_support_desc =>
      'Respond to student questions and provide support in a timely manner.';

  @override
  String get rule_guidelines => 'Follow Guidelines';

  @override
  String get rule_guidelines_desc =>
      'Adhere to our community guidelines and teaching standards at all times.';

  @override
  String get rule_copyright => 'Respect Copyright';

  @override
  String get rule_copyright_desc =>
      'Only use content you have the right to use and respect intellectual property.';

  @override
  String get rule_improvement => 'Continuous Improvement';

  @override
  String get rule_improvement_desc =>
      'Update your courses based on feedback and stay current with your subject.';

  @override
  String get agree_to_terms =>
      'I agree to follow all the rules and requirements listed above';

  @override
  String get must_agree_to_terms =>
      'You must agree to the terms and conditions';

  @override
  String get ai_assistant_coming_soon => 'AI Assistant coming soon!';

  @override
  String get please_login_to_rate => 'Please log in to rate this course';

  @override
  String get ai_assistant => 'AI Assistant';

  @override
  String get rate_course => 'Rate this Course';

  @override
  String get price_cannot_be_negative => 'Price cannot be negative';

  @override
  String get confirm_purchase => 'Confirm Purchase';

  @override
  String get confirm_enroll => 'Yes, Enroll';

  @override
  String get confirm_buy => 'Yes, Buy Now';

  @override
  String get confirm_purchase_message =>
      'Are you sure you want to purchase this course?';

  @override
  String get confirm_enroll_message =>
      'Are you sure you want to enroll in this course?';

  @override
  String get total_amount => 'Total Amount';

  @override
  String get not_enrolled_error =>
      'You must be enrolled in this course to rate it';

  @override
  String get already_rated_error =>
      'You have already rated this course. You can edit your existing rating.';

  @override
  String get invalid_rating_error => 'Rating must be between 1 and 5 stars';

  @override
  String get instructor_cannot_rate_error =>
      'Instructors cannot rate their own courses';

  @override
  String get edit_rating => 'Edit Rating';

  @override
  String get delete_rating => 'Delete Rating';

  @override
  String get delete_rating_confirmation =>
      'Are you sure you want to delete your rating?';

  @override
  String get comment => 'Comment';

  @override
  String get share_your_thoughts => 'Share your thoughts about this course...';

  @override
  String get submit => 'Submit';

  @override
  String get update => 'Update';

  @override
  String get poor => 'Poor';

  @override
  String get fair => 'Fair';

  @override
  String get good => 'Good';

  @override
  String get very_good => 'Very Good';

  @override
  String get excellent => 'Excellent';

  @override
  String get rating_added_successfully => 'Rating added successfully!';

  @override
  String get rating_updated_successfully => 'Rating updated successfully!';

  @override
  String get rating_deleted_successfully => 'Rating deleted successfully!';

  @override
  String get your_rating => 'Your Rating';

  @override
  String get coming_soon => 'Coming soon!';

  @override
  String get just_now => 'Just now';

  @override
  String get no_reviews_yet => 'No reviews yet';

  @override
  String get top_rated_courses => 'Top Rated Courses';

  @override
  String get progress_title => 'Progress';

  @override
  String get progress_overall => 'Overall Progress';

  @override
  String get progress_completed => 'Completed';

  @override
  String get progress_not_completed => 'Not Completed';

  @override
  String get progress_video_completed => 'Video Completed';

  @override
  String get progress_quiz_completed => 'Quiz Completed';

  @override
  String get progress_mark_as_complete => 'Mark as Complete';

  @override
  String get progress_mark_as_incomplete => 'Mark as Incomplete';

  @override
  String get progress_reset => 'Reset Progress';

  @override
  String get progress_reset_confirm_title => 'Reset Progress?';

  @override
  String get progress_reset_confirm_message =>
      'Are you sure you want to reset your progress for this course? This action cannot be undone.';

  @override
  String get progress_reset_success => 'Progress reset successfully';

  @override
  String get progress_loading => 'Loading progress...';

  @override
  String get progress_error => 'Failed to load progress';

  @override
  String get progress_update_error => 'Failed to update progress';

  @override
  String progress_percentage(Object percentage) {
    return '$percentage% Complete';
  }

  @override
  String progress_items_completed(Object completed, Object total) {
    return '$completed of $total items completed';
  }

  @override
  String get progress_continue_learning => 'Continue Learning';

  @override
  String get progress_start_course => 'Start Course';

  @override
  String get progress_course_completed => 'Course Completed! 🎉';

  @override
  String get progress_videos => 'Videos';

  @override
  String get progress_quizzes => 'Quizzes';

  @override
  String get progress_chapter => 'Chapter';

  @override
  String get progress_no_progress => 'No progress yet. Start learning!';

  @override
  String get reset => 'Reset';

  @override
  String get quiz => 'Quiz';

  @override
  String get progress_download_certificate => 'Download Certificate';

  @override
  String get progress_generating_certificate => 'Generating Certificate...';

  @override
  String get progress_certificate_generated => 'Certificate Generated!';

  @override
  String get progress_certificate_saved =>
      'Your certificate has been saved successfully.';

  @override
  String get progress_open_certificate => 'Open';

  @override
  String get progress_certificate_error =>
      'Failed to generate certificate. Please try again.';

  @override
  String get ok => 'OK';

  @override
  String get progress_view_certificate => 'View Certificate';

  @override
  String get progress_share_certificate => 'Share Certificate';

  @override
  String get please_login_to_chat => 'Please login to start chatting with AI';

  @override
  String get chat => 'Chat';

  @override
  String get new_chat => 'New Chat';

  @override
  String get start_new_chat => 'Start New Chat';

  @override
  String get no_chats_yet => 'No Chats Yet';

  @override
  String get start_conversation_with_ai =>
      'Start a conversation with AI assistant to get help with your questions';

  @override
  String get chat_title => 'Chat Title';

  @override
  String get enter_chat_title => 'Enter a title for your chat';

  @override
  String get title_too_short => 'Title must be at least 3 characters';

  @override
  String get create => 'Create';

  @override
  String get delete_chat => 'Delete Chat';

  @override
  String get delete_chat_confirmation =>
      'Are you sure you want to delete this chat? This action cannot be undone.';

  @override
  String get clear_messages => 'Clear Messages';

  @override
  String get clear_messages_confirmation =>
      'Are you sure you want to clear all messages in this chat?';

  @override
  String get clear => 'Clear';

  @override
  String get info => 'Info';

  @override
  String get ai_assistant_info =>
      'This AI assistant can help answer your questions, provide explanations, and assist with various tasks. Feel free to ask anything!';

  @override
  String get type_message => 'Type a message...';

  @override
  String get send => 'Send';

  @override
  String get attach_file => 'Attach File';

  @override
  String get photo => 'Photo';

  @override
  String get file => 'File';

  @override
  String get no_file_selected => 'No file selected';

  @override
  String get start_chatting => 'Start chatting with AI assistant';

  @override
  String get error_occurred => 'An error occurred';

  @override
  String get sending => 'Sending...';

  @override
  String get ai_chat_server_error => 'Server error occurred. Please try again.';

  @override
  String get ai_chat_network_error =>
      'Network connection error. Please check your internet.';

  @override
  String get ai_chat_storage_error => 'File upload failed. Please try again.';

  @override
  String get ai_chat_not_found => 'Chat session not found.';

  @override
  String get ai_chat_ai_error =>
      'AI service is temporarily unavailable. Please try again.';

  @override
  String get ai_chat_api_error => 'API error occurred. Please try again later.';

  @override
  String get ai_chat_rate_limit_error =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get ai_chat_quota_exceeded =>
      'Service quota exceeded. Please try again later.';

  @override
  String get ai_chat_file_too_large =>
      'File is too large. Maximum size is 10MB.';

  @override
  String get ai_chat_invalid_file_format =>
      'Invalid file format. Please select a different file.';

  @override
  String get ai_chat_unknown_error =>
      'An unexpected error occurred. Please try again.';

  @override
  String get ai_chat_permission_denied =>
      'Permission denied. Please check your access.';

  @override
  String get ai_chat_service_unavailable =>
      'Service temporarily unavailable. Please try again later.';

  @override
  String get ai_chat_timeout =>
      'Request timeout. Please check your connection and try again.';

  @override
  String get ai_chat_already_exists => 'This chat already exists.';

  @override
  String get ai_chat_firestore_error =>
      'Database error occurred. Please try again.';

  @override
  String get hour_ago => 'hour ago';

  @override
  String get hours_ago => 'hours ago';

  @override
  String get minute_ago => 'minute ago';

  @override
  String get minutes_ago => 'minutes ago';

  @override
  String get hours_short => 'h';

  @override
  String get minutes_short => 'm';

  @override
  String get seconds_short => 's';

  @override
  String get bytes => 'bytes';

  @override
  String get kilobytes => 'KB';

  @override
  String get megabytes => 'MB';

  @override
  String get gigabytes => 'GB';

  @override
  String get failed_to_pick_image => 'Failed to pick image';

  @override
  String get camera_cancelled => 'Camera operation cancelled';

  @override
  String get failed_to_send_message => 'Failed to send message';

  @override
  String get image_attached => 'Image attached';

  @override
  String get add_message_to_image => 'Add a message to go with your image...';

  @override
  String get quiz_loading => 'Loading quiz...';

  @override
  String get quiz_error_occurred => 'An error occurred';

  @override
  String get quiz_questions_count => 'Questions';

  @override
  String get quiz_time_limit => 'Time Limit';

  @override
  String get quiz_passing_score => 'Passing Score';

  @override
  String get quiz_previous_attempt => 'Previous Attempt';

  @override
  String get quiz_score => 'Score';

  @override
  String get quiz_percentage => 'Percentage';

  @override
  String get quiz_retake => 'Retake Quiz';

  @override
  String get quiz_start => 'Start Quiz';

  @override
  String get quiz_previous => 'Previous';

  @override
  String get quiz_next => 'Next';

  @override
  String get quiz_submit => 'Submit Quiz';

  @override
  String get quiz_submit_confirmation_title => 'Submit Quiz?';

  @override
  String quiz_submit_with_unanswered(int count) {
    return 'You have $count unanswered questions. Are you sure you want to submit?';
  }

  @override
  String get quiz_submit_all_answered =>
      'You have answered all questions. Are you sure you want to submit?';

  @override
  String get quiz_passed => 'Congratulations!';

  @override
  String get quiz_failed => 'Keep Trying!';

  @override
  String get quiz_passed_message => 'You passed the quiz successfully!';

  @override
  String get quiz_failed_message =>
      'You didn\'t pass this time, but you can try again.';

  @override
  String get quiz_time_taken => 'Time Taken';

  @override
  String get quiz_correct_answers => 'Correct';

  @override
  String get quiz_wrong_answers => 'Wrong';

  @override
  String get quiz_review_answers => 'Review Answers';

  @override
  String get quiz_explanation => 'Explanation';

  @override
  String get quiz_correct_answer => 'Correct Answer';

  @override
  String get quiz_your_answer => 'Your Answer';

  @override
  String get errConferenceNotLive => 'Conference is not currently live';

  @override
  String get errAccessNotPurchased =>
      'You have not purchased access to this conference';

  @override
  String get errJoinTimeLimitExceeded =>
      'Join time limit exceeded. You can only join within 10 minutes of start time';

  @override
  String get errConferenceFull => 'Conference has reached maximum participants';

  @override
  String get liveConferences => 'Live Conferences';

  @override
  String get createConference => 'Create Conference';

  @override
  String get conferenceTitle => 'Conference Title';

  @override
  String get conferenceDescription => 'Description';

  @override
  String get conferencePrice => 'Price';

  @override
  String get maxDuration => 'Maximum Duration (minutes)';

  @override
  String get maxParticipants => 'Maximum Participants';

  @override
  String get scheduledStartTime => 'Scheduled Start Time';

  @override
  String get startConference => 'Start Conference';

  @override
  String get endConference => 'End Conference';

  @override
  String get joinConference => 'Join Conference';

  @override
  String get purchaseAccess => 'Purchase Access';

  @override
  String get conferenceLive => 'LIVE';

  @override
  String get conferenceScheduled => 'Scheduled';

  @override
  String get conferenceEnded => 'Ended';

  @override
  String get participants => 'Participants';

  @override
  String get startsIn => 'Starts in';

  @override
  String startedAgo(String time) {
    return 'Started $time ago';
  }

  @override
  String youCanJoinFor(String minutes) {
    return 'You can join for $minutes more minutes';
  }

  @override
  String get joinWindowClosed => 'Join window closed';

  @override
  String get conferenceFull => 'Full';

  @override
  String get purchaseRequired => 'Purchase Required';

  @override
  String get alreadyPurchased => 'Access Purchased';

  @override
  String get free => 'Free';

  @override
  String get createConferenceSuccess => 'Conference created successfully';

  @override
  String get purchaseSuccess => 'Access purchased successfully';

  @override
  String get joinSuccess => 'Joined conference successfully';

  @override
  String get endConferenceConfirm =>
      'Are you sure you want to end this conference?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get noActiveConferences => 'No active conferences available';

  @override
  String get loadingConferences => 'Loading conferences...';

  @override
  String get duration => 'Duration';

  @override
  String get roomId => 'Room ID';

  @override
  String get conferenceNotStarted => 'Conference has not started yet';

  @override
  String get conferenceNotAvailable => 'Conference is not available';

  @override
  String get enterConferenceTitle => 'Enter Conference Title';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get titleMinLength => 'Title must be at least 3 characters';

  @override
  String get enterConferenceDescription => 'Enter Conference Description';

  @override
  String get pleaseEnterDescription => 'Please enter a description';

  @override
  String get descriptionMinLength =>
      'Description must be at least 10 characters';

  @override
  String get pleaseEnterPrice => 'Please enter a price';

  @override
  String get pleaseEnterValidPrice => 'Please enter a valid price';

  @override
  String get pleaseEnterMaxParticipants => 'Please enter maximum participants';

  @override
  String get participantsRange => 'Participants must be between 2 and 1000';

  @override
  String get scheduledTimeFuture => 'Scheduled time must be in the future';

  @override
  String get userNotAuthenticated => 'User is not authenticated';

  @override
  String get conferenceDeleted => 'Conference deleted successfully';

  @override
  String get deleteConference => 'Delete Conference';

  @override
  String get deleteConferenceConfirm =>
      'Are you sure you want to delete this conference?';

  @override
  String get pleaseEnterMaxDuration => 'Please enter maximum duration';

  @override
  String get durationRange => 'Duration must be between 15 and 480 minutes';
}
