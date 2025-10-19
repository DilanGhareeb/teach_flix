import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_rating_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CourseRatingDialog extends StatefulWidget {
  final String courseId;
  final String userId;
  final CourseRatingEntity? existingRating;

  const CourseRatingDialog({
    super.key,
    required this.courseId,
    required this.userId,
    this.existingRating,
  });

  @override
  State<CourseRatingDialog> createState() => _CourseRatingDialogState();
}

class _CourseRatingDialogState extends State<CourseRatingDialog> {
  late double _rating;
  late TextEditingController _commentController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.existingRating != null;
    _rating = widget.existingRating?.rating ?? 5.0;
    _commentController = TextEditingController(
      text: widget.existingRating?.comment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;

    // Adjust sizes dynamically
    final double basePadding = isSmallScreen ? 16 : 24;
    final double starSize = isSmallScreen ? 32 : 40;
    final double titleFontSize = isSmallScreen ? 18 : 22;
    final double buttonFontSize = isSmallScreen ? 14 : 16;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : size.width * 0.15,
        vertical: isSmallScreen ? 16 : size.height * 0.1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600, // keeps it nice on tablets/desktops
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(basePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _isEditing
                          ? (t.edit_rating ?? 'Edit Rating')
                          : (t.rate_course ?? 'Rate Course'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: basePadding),

              // Rating Stars
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        size: starSize,
                        color: Colors.amber[700],
                      ),
                      onPressed: () {
                        setState(() {
                          _rating = (index + 1).toDouble();
                        });
                      },
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),

              // Rating label text
              Center(
                child: Text(
                  _getRatingText(_rating, t),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: basePadding),

              // Comment field
              TextField(
                controller: _commentController,
                maxLines: 4,
                maxLength: 500,
                style: TextStyle(fontSize: isSmallScreen ? 13 : 15),
                decoration: InputDecoration(
                  labelText: t.comment ?? 'Comment',
                  hintText:
                      t.share_your_thoughts ??
                      'Share your thoughts about this course...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                  contentPadding: EdgeInsets.all(isSmallScreen ? 10 : 14),
                ),
              ),
              SizedBox(height: basePadding),

              // Buttons
              Row(
                children: [
                  if (_isEditing) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteConfirmation(context, t),
                        icon: Icon(
                          Icons.delete_outline,
                          size: isSmallScreen ? 18 : 20,
                        ),
                        label: Text(
                          t.delete ?? 'Delete',
                          style: TextStyle(fontSize: buttonFontSize),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 10 : 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _submitRating(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: isSmallScreen ? 10 : 12,
                        ),
                      ),
                      child: Text(
                        _isEditing
                            ? (t.update ?? 'Update')
                            : (t.submit ?? 'Submit'),
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingText(double rating, AppLocalizations t) {
    if (rating <= 1) return t.poor ?? 'Poor';
    if (rating <= 2) return t.fair ?? 'Fair';
    if (rating <= 3) return t.good ?? 'Good';
    if (rating <= 4) return t.very_good ?? 'Very Good';
    return t.excellent ?? 'Excellent';
  }

  void _submitRating(BuildContext context) {
    final comment = _commentController.text.trim();

    if (_isEditing) {
      context.read<CoursesBloc>().add(
        UpdateRatingEvent(
          ratingId: widget.existingRating!.id,
          rating: _rating,
          comment: comment,
        ),
      );
    } else {
      context.read<CoursesBloc>().add(
        AddRatingEvent(
          userId: widget.userId,
          courseId: widget.courseId,
          rating: _rating,
          comment: comment,
        ),
      );
    }

    Navigator.of(context).pop();
  }

  void _showDeleteConfirmation(BuildContext context, AppLocalizations t) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          t.delete_rating ?? 'Delete Rating',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          t.delete_rating_confirmation ??
              'Are you sure you want to delete your rating?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(t.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CoursesBloc>().add(
                DeleteRatingEvent(ratingId: widget.existingRating!.id),
              );
              Navigator.of(dialogContext).pop(); // confirmation
              Navigator.of(context).pop(); // rating dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(t.delete ?? 'Delete'),
          ),
        ],
      ),
    );
  }
}
