import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/common/error_localizer.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/pages/create_conference_form.dart';
import 'package:teach_flix/src/features/live_conference/presentation/pages/conference_room_page.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CreateConferencePage extends StatelessWidget {
  const CreateConferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createConference), elevation: 0),
      body: BlocConsumer<LiveConferenceBloc, LiveConferenceState>(
        listenWhen: (previous, current) =>
            previous.status != current.status &&
            (current.status == LiveConferenceStatus.created ||
                current.status == LiveConferenceStatus.error),
        listener: (context, state) {
          if (state.status == LiveConferenceStatus.created &&
              state.selectedConference != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.createConferenceSuccess),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<LiveConferenceBloc>(),
                  child: ConferenceRoomPage(
                    conference: state.selectedConference!,
                  ),
                ),
              ),
            );
          } else if (state.status == LiveConferenceStatus.error &&
              state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(ErrorLocalizer.of(state.failure!, l10n)),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isCreating = state.status == LiveConferenceStatus.creating;
          return CreateConferenceForm(isLoading: isCreating);
        },
      ),
    );
  }
}
