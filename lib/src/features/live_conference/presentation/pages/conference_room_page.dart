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

  @override
  void initState() {
    super.initState();

    // ✅ After first frame, auto-start for instructor
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authBloc = context.read<AuthBloc>();
      final user = authBloc.state.user;

      if (user == null) {
        setState(() {
          _errorMessage = 'User not authenticated';
        });
        return;
      }

      final isInstructor = user.id == widget.conference.instructorId;

      // 1) Make sure TUIRoomEngine is logged in for this user
      await TencentRtcInitializer.ensureLoggedIn();

      // 2) Only auto-start if this user is the instructor
      if (isInstructor) {
        await _startConference(context, user.id, user.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;
    final userId = user?.id;
    final userName = user?.name ?? 'User';
    final isInstructor = userId == widget.conference.instructorId;

    return Scaffold(
      appBar: AppBar(title: Text(widget.conference.title), elevation: 0),
      body: ConferenceLobby(
        conference: widget.conference,
        isInstructor: isInstructor,
        isJoining: _isJoining,
        errorMessage: _errorMessage,
        onJoinConference: () =>
            _joinConference(context, userId, userName, isInstructor),
        onStartConference: () => _startConference(context, userId, userName),
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
      // ✅ Ensure TUIRoomEngine is logged in
      await TencentRtcInitializer.ensureLoggedIn();

      // Join the conference via bloc
      context.read<LiveConferenceBloc>().add(
        JoinConferenceRequested(widget.conference.id),
      );

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
      // ✅ Ensure TUIRoomEngine is logged in
      await TencentRtcInitializer.ensureLoggedIn();

      // Start the conference - update status to 'live'
      context.read<LiveConferenceBloc>().add(
        StartConferenceRequested(widget.conference.id),
      );

      // Wait for status update
      await Future.delayed(const Duration(milliseconds: 500));

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
      // ✅ 1) Make sure Tencent is logged in
      final ok = await TencentRtcInitializer.ensureLoggedIn();
      if (!ok) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Failed to connect to video service.';
          });
        }
        return;
      }

      // ✅ 2) Set user info (after login)
      await TUIRoomEngine.setSelfInfo(userName, '');

      // ✅ 3) Create session
      final session = ConferenceSession.newInstance(widget.conference.roomId)
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

      // ✅ 4) Start or join
      if (isInstructor) {
        session.quickStart();
      } else {
        session.join();
      }

      // ✅ 5) Navigate to Tencent UI
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
