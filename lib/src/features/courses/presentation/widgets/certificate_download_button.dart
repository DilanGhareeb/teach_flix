import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/utils/certificate_generator.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/courses/domain/entities/course_entity.dart';
import 'package:teach_flix/src/features/courses/presentation/bloc/courses_bloc.dart';
import 'package:teach_flix/src/features/courses/presentation/widgets/certificate_viewer_dialog.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CertificateDownloadButton extends StatefulWidget {
  final String courseId;

  const CertificateDownloadButton({super.key, required this.courseId});

  @override
  State<CertificateDownloadButton> createState() =>
      _CertificateDownloadButtonState();
}

class _CertificateDownloadButtonState extends State<CertificateDownloadButton> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      onPressed: _isGenerating ? null : () => _downloadCertificate(context),
      icon: _isGenerating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.workspace_premium, size: 20),
      label: Text(
        _isGenerating
            ? (t.progress_generating_certificate ?? 'Generating...')
            : (t.progress_download_certificate ?? 'Download Certificate'),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _downloadCertificate(BuildContext context) async {
    final t = AppLocalizations.of(context)!;
    setState(() => _isGenerating = true);

    try {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;
      final userName = authState.user?.name ?? 'Student';

      final coursesState = context.read<CoursesBloc>().state;
      final courses = coursesState.courses ?? [];

      if (courses.isEmpty) {
        if (mounted) setState(() => _isGenerating = false);
        _showErrorSnackbar(context, t);
        return;
      }

      CourseEntity course;
      try {
        course = courses.firstWhere((c) => c.id == widget.courseId);
      } catch (e) {
        // If course not found, use first course as fallback
        course = courses.first;
      }

      final instructorId = course.instructorId ?? '';

      final certGen = CertificateGenerator();
      final filePath = await certGen.generateAndSaveCertificate(
        userName: userName,
        courseName: course.title,
        instructorId: instructorId,
        getInstructorName: authBloc.getInstructorName,
      );

      if (mounted) {
        setState(() => _isGenerating = false);
        if (filePath != null) {
          // Show the certificate viewer dialog
          _showCertificateViewer(context, filePath, userName, course.title);
        } else {
          _showErrorSnackbar(context, t);
        }
      }
    } catch (e, st) {
      print('Certificate generation error: $e\n$st');
      if (mounted) {
        setState(() => _isGenerating = false);
        _showErrorSnackbar(context, t);
      }
    }
  }

  void _showCertificateViewer(
    BuildContext context,
    String filePath,
    String userName,
    String courseName,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => CertificateViewerDialog(
        filePath: filePath,
        userName: userName,
        courseName: courseName,
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, AppLocalizations t) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                t.progress_certificate_error ??
                    'Failed to generate certificate',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
