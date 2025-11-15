import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_lobby.dart';
import 'package:teach_flix/src/features/live_conference/presentation/pages/agora_call_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

/// Conference room page that displays lobby and handles conference lifecycle
class ConferenceRoomPage extends StatefulWidget {
  final LiveConference conference;

  const ConferenceRoomPage({super.key, required this.conference});

  @override
  State<ConferenceRoomPage> createState() => _ConferenceRoomPageState();
}

class _ConferenceRoomPageState extends State<ConferenceRoomPage> {
  bool _isJoining = false;
  String? _errorMessage;
  LiveConference? _currentConference;

  @override
  void initState() {
    super.initState();
    _currentConference = widget.conference;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;
    final userId = user?.id;
    final userName = user?.name ?? 'User';
    final isInstructor = userId == _currentConference!.instructorId;

    return BlocListener<LiveConferenceBloc, LiveConferenceState>(
      listener: (context, state) =>
          _handleConferenceStateChanges(context, state, l10n),
      child: Scaffold(
        appBar: _buildAppBar(context, l10n, isInstructor),
        body: ConferenceLobby(
          conference: _currentConference!,
          isInstructor: isInstructor,
          isJoining: _isJoining,
          errorMessage: _errorMessage,
          onJoinConference: () =>
              _handleJoinConference(context, userId, userName, isInstructor),
          onStartConference: () =>
              _handleStartConference(context, userId, userName),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
    bool isInstructor,
  ) {
    return AppBar(
      title: Text(_currentConference!.title),
      elevation: 0,
      actions: [
        if (isInstructor && !(_currentConference!.isLive ?? false))
          _buildDeleteMenu(context, l10n),
      ],
    );
  }

  Widget _buildDeleteMenu(BuildContext context, AppLocalizations l10n) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'delete') {
          _showDeleteConfirmationDialog(context, l10n);
        }
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                l10n.deleteConference ?? 'Delete conference',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleConferenceStateChanges(
    BuildContext context,
    LiveConferenceState state,
    AppLocalizations l10n,
  ) {
    // Keep local conference in sync with bloc
    if (state.activeConferences.isNotEmpty) {
      final updated = state.activeConferences.firstWhere(
        (conf) => conf.id == _currentConference!.id,
        orElse: () => _currentConference!,
      );
      if (mounted && updated != _currentConference) {
        setState(() {
          _currentConference = updated;
        });
      }
    }

    // Handle deleted status
    if (state.status.toString().contains('deleted')) {
      _showSuccessMessage(
        context,
        l10n.conferenceDeleted ?? 'Conference deleted successfully',
      );
      Navigator.pop(context);
    }
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteConference ?? 'Delete conference'),
        content: Text(
          l10n.deleteConferenceConfirm ??
              'Are you sure you want to delete this conference? '
                  'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.no),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<LiveConferenceBloc>().add(
                DeleteConferenceRequested(_currentConference!.id),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }

  Future<void> _handleJoinConference(
    BuildContext context,
    String? userId,
    String userName,
    bool isInstructor,
  ) async {
    if (!_validateUser(userId)) return;
    if (!_validateRoomId()) return;

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // Students mark joined in backend
      if (!isInstructor) {
        context.read<LiveConferenceBloc>().add(
          JoinConferenceRequested(_currentConference!.id),
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));

      if (!mounted) return;

      debugPrint(
        '[JOIN] user=$userName, isInstructor=$isInstructor, '
        'roomId=${_currentConference!.roomId}',
      );

      await _navigateToCall(
        context,
        userId: userId!,
        userName: userName,
        isInstructor: isInstructor,
      );
    } catch (e) {
      _setError('Failed to join conference: $e');
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  Future<void> _handleStartConference(
    BuildContext context,
    String? userId,
    String userName,
  ) async {
    if (!_validateUser(userId)) return;
    if (!_validateRoomId()) return;

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // Instructor marks conference as live
      context.read<LiveConferenceBloc>().add(
        StartConferenceRequested(_currentConference!.id),
      );

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      debugPrint(
        '[START] Instructor $userName starting live, '
        'roomId=${_currentConference!.roomId}',
      );

      await _navigateToCall(
        context,
        userId: userId!,
        userName: userName,
        isInstructor: true,
      );
    } catch (e) {
      _setError('Failed to start conference: $e');
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  Future<void> _navigateToCall(
    BuildContext context, {
    required String userId,
    required String userName,
    required bool isInstructor,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AgoraCallPage(
          conferenceId: _currentConference!.id, // Pass conference ID
          channelId: _currentConference!.roomId,
          userId: userId, // Pass user ID
          userName: userName,
          isInstructor: isInstructor,
        ),
      ),
    );
  }

  bool _validateUser(String? userId) {
    if (userId == null) {
      _setError('User not authenticated');
      return false;
    }
    return true;
  }

  bool _validateRoomId() {
    if (_currentConference!.roomId.isEmpty) {
      _setError('Conference room is not configured (empty roomId).');
      return false;
    }
    return true;
  }

  void _setError(String message) {
    setState(() => _errorMessage = message);
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }
}
