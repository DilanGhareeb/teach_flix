// conference_room_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tencent_conference_uikit/tencent_conference_uikit.dart';
import 'package:rtc_room_engine/rtc_room_engine.dart';
import 'package:teach_flix/src/core/rtc/tencent_rtc_initializer.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/entities/live_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_lobby.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

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
    // REMOVED auto-start logic - instructor needs to manually start/join
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
      listener: (context, state) {
        // Update conference when it changes
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

        // Handle deletion
        if (state.status == LiveConferenceStatus.deleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                l10n.conferenceDeleted ?? 'Conference deleted successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_currentConference!.title),
          elevation: 0,
          actions: [
            if (isInstructor && !_currentConference!.isLive) ...[
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteConfirmation(context, l10n);
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
                          l10n.deleteConference ?? 'Delete Conference',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        body: ConferenceLobby(
          conference: _currentConference!,
          isInstructor: isInstructor,
          isJoining: _isJoining,
          errorMessage: _errorMessage,
          onJoinConference: () =>
              _joinConference(context, userId, userName, isInstructor),
          onStartConference: () => _startConference(context, userId, userName),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteConference ?? 'Delete Conference'),
        content: Text(
          l10n.deleteConferenceConfirm ??
              'Are you sure you want to delete this conference? This action cannot be undone.',
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

  Future<void> _joinConference(
    BuildContext context,
    String? userId,
    String userName,
    bool isInstructor,
  ) async {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;

    if (user == null || userId == null) {
      setState(() {
        _errorMessage = 'User not authenticated';
      });
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // Ensure TUIRoomEngine is logged in
      await TencentRtcInitializer.ensureLoggedIn();

      // Join the conference via bloc
      if (!isInstructor) {
        context.read<LiveConferenceBloc>().add(
          JoinConferenceRequested(_currentConference!.id),
        );
      }

      // Wait a bit for the backend to update
      await Future.delayed(const Duration(milliseconds: 500));

      // Navigate to Tencent Conference UI
      await _navigateToTencentConference(
        context,
        userId,
        userName,
        isInstructor,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to join conference: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  Future<void> _startConference(
    BuildContext context,
    String? userId,
    String userName,
  ) async {
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;

    if (user == null || userId == null) {
      setState(() {
        _errorMessage = 'User not authenticated';
      });
      return;
    }

    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      // Ensure TUIRoomEngine is logged in
      await TencentRtcInitializer.ensureLoggedIn();

      // Start the conference - update status to 'live'
      context.read<LiveConferenceBloc>().add(
        StartConferenceRequested(_currentConference!.id),
      );

      // Wait for status update
      await Future.delayed(const Duration(seconds: 1));

      // Navigate to Tencent Conference UI
      await _navigateToTencentConference(
        context,
        userId,
        userName,
        true, // isInstructor
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to start conference: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isJoining = false;
        });
      }
    }
  }

  Future<void> _navigateToTencentConference(
    BuildContext context,
    String userId,
    String userName,
    bool isInstructor,
  ) async {
    try {
      // 1) Make sure Tencent is logged in
      final ok = await TencentRtcInitializer.ensureLoggedIn();
      if (!ok) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to connect to video service.';
          });
        }
        return;
      }

      // 2) Set user info (after login)
      await TUIRoomEngine.setSelfInfo(userName, '');

      // 3) Create session
      final session = ConferenceSession.newInstance(_currentConference!.roomId)
        ..onActionSuccess = () {
          debugPrint('Conference session created successfully');
        }
        ..onActionError = (error, message) {
          debugPrint('Conference error: $error - $message');
          if (mounted) {
            setState(() {
              _errorMessage = message;
            });
          }
        };

      // 4) Start or join
      if (isInstructor) {
        session.quickStart();
      } else {
        session.join();
      }

      // 5) Navigate to Tencent UI
      if (mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ConferenceMainPage()),
        );

        // When user exits Tencent UI, pop back to previous page
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('Error navigating to conference: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to join conference: ${e.toString()}';
        });
      }
    }
  }
}
