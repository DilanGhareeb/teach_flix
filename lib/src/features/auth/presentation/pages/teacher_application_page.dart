import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/auth/domain/entities/user.dart';
import 'package:teach_flix/src/features/auth/domain/usecase/update_user_info_usecase.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class TeacherApplicationPage extends StatefulWidget {
  const TeacherApplicationPage({super.key});

  @override
  State<TeacherApplicationPage> createState() => _TeacherApplicationPageState();
}

class _TeacherApplicationPageState extends State<TeacherApplicationPage> {
  bool _agreedToTerms = false;
  bool _isSubmitting = false;
  bool _hasNavigated = false;

  void _submitApplication() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.must_agree_to_terms ??
                'You must agree to the terms and conditions',
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Update user role to instructor
    final updateParams = UpdateUserParams(
      null,
      null,
      null,
      role: Role.instructor,
    );

    context.read<AuthBloc>().add(AuthUpdateUserRequested(updateParams));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(title: Text(t.apply_teacher), elevation: 0),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (_hasNavigated) return;

          if (state.status == AuthStatus.authenticated && _isSubmitting) {
            _hasNavigated = true;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.application_submitted ??
                            'Application submitted successfully!',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );

            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          } else if (state.status == AuthStatus.failure && _isSubmitting) {
            setState(() {
              _isSubmitting = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(t.application_failed ?? 'Application failed'),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [cs.primary, cs.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.school_rounded, size: 48, color: cs.onPrimary),
                      const SizedBox(height: 16),
                      Text(
                        t.become_instructor ?? 'Become an Instructor',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.share_your_knowledge ??
                            'Share your knowledge with thousands of students',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onPrimary.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Rules Section
                Text(
                  t.instructor_rules ?? 'Instructor Requirements & Rules',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),

                const SizedBox(height: 16),

                // Rules List
                _buildRuleCard(
                  context,
                  icon: Icons.verified_rounded,
                  title: t.rule_quality ?? 'Quality Content',
                  description:
                      t.rule_quality_desc ??
                      'Create high-quality, original courses that provide real value to students.',
                ),

                const SizedBox(height: 12),

                _buildRuleCard(
                  context,
                  icon: Icons.schedule_rounded,
                  title: t.rule_commitment ?? 'Time Commitment',
                  description:
                      t.rule_commitment_desc ??
                      'Dedicate sufficient time to create, update, and maintain your courses regularly.',
                ),

                const SizedBox(height: 12),

                _buildRuleCard(
                  context,
                  icon: Icons.support_agent_rounded,
                  title: t.rule_support ?? 'Student Support',
                  description:
                      t.rule_support_desc ??
                      'Respond to student questions and provide support in a timely manner.',
                ),

                const SizedBox(height: 12),

                _buildRuleCard(
                  context,
                  icon: Icons.gavel_rounded,
                  title: t.rule_guidelines ?? 'Follow Guidelines',
                  description:
                      t.rule_guidelines_desc ??
                      'Adhere to our community guidelines and teaching standards at all times.',
                ),

                const SizedBox(height: 12),

                _buildRuleCard(
                  context,
                  icon: Icons.copyright_rounded,
                  title: t.rule_copyright ?? 'Respect Copyright',
                  description:
                      t.rule_copyright_desc ??
                      'Only use content you have the right to use and respect intellectual property.',
                ),

                const SizedBox(height: 12),

                _buildRuleCard(
                  context,
                  icon: Icons.trending_up_rounded,
                  title: t.rule_improvement ?? 'Continuous Improvement',
                  description:
                      t.rule_improvement_desc ??
                      'Update your courses based on feedback and stay current with your subject.',
                ),

                const SizedBox(height: 32),

                // Agreement Checkbox
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _agreedToTerms
                          ? cs.primary
                          : cs.outline.withOpacity(0.3),
                      width: _agreedToTerms ? 2 : 1,
                    ),
                  ),
                  child: CheckboxListTile(
                    value: _agreedToTerms,
                    onChanged: _isSubmitting
                        ? null
                        : (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      t.agree_to_terms ??
                          'I agree to follow all the rules and requirements listed above',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    activeColor: cs.primary,
                  ),
                ),

                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: _isSubmitting ? null : _submitApplication,
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            t.submit_application ?? 'Submit Application',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // Info Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          t.application_review_info ??
                              'Your application will be reviewed by our team. You will be notified once approved.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: cs.primary, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
