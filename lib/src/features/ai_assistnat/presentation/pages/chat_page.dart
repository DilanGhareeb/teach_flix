import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/bloc/ai_chat_bloc.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/pages/chat_detail_page.dart';
import 'package:teach_flix/src/features/ai_assistnat/presentation/pages/chat_session_page.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_state.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/service_locator.dart';

class AiChatPage extends StatelessWidget {
  const AiChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    if (authState.status != AuthStatus.authenticated) {
      return Scaffold(
        body: Center(
          child: Text(AppLocalizations.of(context)!.please_login_to_chat),
        ),
      );
    }

    return BlocProvider(
      create: (context) =>
          sl<AiChatBloc>()..add(AiChatSessionRequested(authState.user!.id)),
      child: const _AiChatPageContent(),
    );
  }
}

class _AiChatPageContent extends StatelessWidget {
  const _AiChatPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AiChatBloc, AiChatState>(
      builder: (context, state) {
        if (state.currentSession != null) {
          return const ChatDetailPage();
        }
        return const ChatSessionsPage();
      },
    );
  }
}
