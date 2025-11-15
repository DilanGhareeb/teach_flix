import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/core/utils/formatter.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/pages/conference_room_page.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/join_time_warning.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'dart:async';

/// Conference action buttons with spam prevention
class ConferenceActionButtons extends StatefulWidget {
  final LiveConference conference;
  final bool isInstructor;

  const ConferenceActionButtons({
    super.key,
    required this.conference,
    required this.isInstructor,
  });

  @override
  State<ConferenceActionButtons> createState() =>
      _ConferenceActionButtonsState();
}

class _ConferenceActionButtonsState extends State<ConferenceActionButtons> {
  Timer? _debounceTimer;
  bool _isProcessing = false;
  String? _lastAction;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleAction(String actionKey, VoidCallback action) {
    // Prevent duplicate actions within 2 seconds
    if (_isProcessing || _lastAction == actionKey) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait...'),
          duration: Duration(milliseconds: 500),
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastAction = actionKey;
    });

    action();

    // Reset after delay
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _lastAction = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.isInstructor) {
      return _buildInstructorButton(context, l10n);
    }

    if (!widget.conference.canJoin) {
      return JoinTimeWarning(conference: widget.conference);
    }

    if (widget.conference.isFull) {
      return _buildFullMessage(context, l10n);
    }

    final remainingMinutes = Formatter.calculateRemainingJoinMinutes(
      widget.conference.actualStartTime,
    );

    if (remainingMinutes > 0) {
      return Column(
        children: [
          JoinTimeWarning(conference: widget.conference),
          const SizedBox(height: 8),
          _buildStudentButton(context, l10n),
        ],
      );
    }

    return _buildStudentButton(context, l10n);
  }

  Widget _buildInstructorButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isProcessing
            ? null
            : () => _handleAction('navigate', () => _navigateToRoom(context)),
        icon: _isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.video_call),
        label: Text(l10n.joinConference),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildFullMessage(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.group_off, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              l10n.conferenceFull,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentButton(BuildContext context, AppLocalizations l10n) {
    final authState = context.read<AuthBloc>().state;
    final userId = authState.user?.id;

    if (authState.status != AuthStatus.authenticated || userId == null) {
      return _buildLoginButton(context);
    }

    final hasPurchased = widget.conference.enrolledStudentIds.contains(userId);

    if (hasPurchased || widget.conference.price == 0) {
      return _buildJoinButton(context, l10n);
    }

    return _buildPurchaseButton(context, l10n);
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please login to join the conference'),
            ),
          );
        },
        icon: const Icon(Icons.login),
        label: const Text('Login to Join'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isProcessing
            ? null
            : () => _handleAction('join', () {
                context.read<LiveConferenceBloc>().add(
                  JoinConferenceRequested(widget.conference.id),
                );
                _navigateToRoom(context);
              }),
        icon: _isProcessing
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.video_call),
        label: Text(l10n.joinConference),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }

  Widget _buildPurchaseButton(BuildContext context, AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<LiveConferenceBloc, LiveConferenceState>(
        builder: (context, state) {
          final isPurchasing = state.status == LiveConferenceStatus.purchasing;
          final isDisabled = isPurchasing || _isProcessing;

          return ElevatedButton.icon(
            onPressed: isDisabled
                ? null
                : () => _handleAction(
                    'purchase',
                    () => _showPurchaseDialog(context, l10n),
                  ),
            icon: isDisabled
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.shopping_cart),
            label: Text(
              '${l10n.purchaseAccess} - ${Formatter.formatIqd(widget.conference.price)}',
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Colors.purple,
            ),
          );
        },
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, AppLocalizations l10n) {
    final authBloc = context.read<AuthBloc>();
    final userBalance = authBloc.state.user?.balance ?? 0.0;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent accidental dismissal
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.purchaseAccess),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${l10n.conferenceTitle}: ${widget.conference.title}'),
            const SizedBox(height: 8),
            Text(
              '${l10n.conferencePrice}: ${Formatter.formatIqd(widget.conference.price)}',
            ),
            const SizedBox(height: 8),
            Text('Your Balance: ${Formatter.formatIqd(userBalance)}'),
            const SizedBox(height: 16),
            if (userBalance < widget.conference.price)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.errInsufficientBalance,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Reset processing state when dialog is cancelled
              setState(() {
                _isProcessing = false;
                _lastAction = null;
              });
            },
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: userBalance >= widget.conference.price
                ? () {
                    Navigator.pop(dialogContext);
                    context.read<LiveConferenceBloc>().add(
                      PurchaseConferenceAccessRequested(widget.conference.id),
                    );
                  }
                : null,
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }

  void _navigateToRoom(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LiveConferenceBloc>(),
          child: ConferenceRoomPage(conference: widget.conference),
        ),
      ),
    );
  }
}
