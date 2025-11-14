// lib/src/features/live_conference/presentation/pages/active_conferences_page.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/pages/create_conference_page.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_card.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/conference_error_widget.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/empty_conferences_widget.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';
import 'package:teach_flix/src/service_locator.dart';

class ActiveConferencesPage extends StatelessWidget {
  const ActiveConferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide LiveConferenceBloc locally - only created when this page is opened
    return BlocProvider(
      create: (_) =>
          sl<LiveConferenceBloc>()..add(WatchActiveConferencesRequested()),
      child: const _ActiveConferencesView(),
    );
  }
}

class _ActiveConferencesView extends StatelessWidget {
  const _ActiveConferencesView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Watch AuthBloc so UI updates if role changes
    final authState = context.watch<AuthBloc>().state;

    // Adjust this depending on your User model:
    // In MainPage you used: authState.user?.role.name.toLowerCase()
    final roleName = authState.user?.role.name.toLowerCase();
    final isInstructor = roleName == 'instructor' || roleName == 'teacher';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.liveConferences), elevation: 0),
      floatingActionButton: isInstructor
          ? FloatingActionButton.extended(
              heroTag: null, // 👈 no Hero at all
              onPressed: () => _navigateToCreate(context),
              icon: const Icon(Icons.add),
              label: Text(l10n.createConference),
            )
          : null,
      body: BlocConsumer<LiveConferenceBloc, LiveConferenceState>(
        listenWhen: (previous, current) =>
            _shouldShowSnackbar(previous, current),
        listener: _handleStateChanges,
        builder: (context, state) => _buildBody(context, state, l10n),
      ),
    );
  }

  bool _shouldShowSnackbar(
    LiveConferenceState previous,
    LiveConferenceState current,
  ) {
    return previous.status != current.status &&
        (current.status == LiveConferenceStatus.purchased ||
            current.status == LiveConferenceStatus.joined);
  }

  void _handleStateChanges(BuildContext context, LiveConferenceState state) {
    final l10n = AppLocalizations.of(context)!;

    if (state.status == LiveConferenceStatus.purchased) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.purchaseSuccess),
          backgroundColor: Colors.green,
        ),
      );
      context.read<LiveConferenceBloc>().add(WatchActiveConferencesRequested());
    } else if (state.status == LiveConferenceStatus.joined) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.joinSuccess),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildBody(
    BuildContext context,
    LiveConferenceState state,
    AppLocalizations l10n,
  ) {
    if (state.status == LiveConferenceStatus.loading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.loadingConferences),
          ],
        ),
      );
    }

    if (state.status == LiveConferenceStatus.error) {
      return ConferenceErrorWidget(
        failure: state.failure,
        onRetry: () {
          context.read<LiveConferenceBloc>().add(
            WatchActiveConferencesRequested(),
          );
        },
      );
    }

    if (state.activeConferences.isEmpty) {
      return const EmptyConferencesWidget();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LiveConferenceBloc>().add(
          WatchActiveConferencesRequested(),
        );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.activeConferences.length,
        itemBuilder: (context, index) {
          return ConferenceCard(conference: state.activeConferences[index]);
        },
      ),
    );
  }

  void _navigateToCreate(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<LiveConferenceBloc>(),
          child: const CreateConferencePage(),
        ),
      ),
    );
  }
}
