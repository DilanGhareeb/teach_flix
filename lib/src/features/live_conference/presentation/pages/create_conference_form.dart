// create_conference_form.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach_flix/src/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:teach_flix/src/features/live_conference/domain/usecases/create_conference.dart';
import 'package:teach_flix/src/features/live_conference/presentation/bloc/live_conference_bloc.dart';
import 'package:teach_flix/src/features/live_conference/presentation/widgets/date_time_picker_field.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class CreateConferenceForm extends StatefulWidget {
  final bool isLoading;

  const CreateConferenceForm({super.key, required this.isLoading});

  @override
  State<CreateConferenceForm> createState() => _CreateConferenceFormState();
}

class _CreateConferenceFormState extends State<CreateConferenceForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController(text: '0');
  final _maxDurationController = TextEditingController(text: '60');
  final _maxParticipantsController = TextEditingController(text: '50');

  DateTime _scheduledStartTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _maxDurationController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTitleField(l10n),
          const SizedBox(height: 16),
          _buildDescriptionField(l10n),
          const SizedBox(height: 16),
          _buildPriceField(l10n),
          const SizedBox(height: 16),
          DateTimePickerField(
            label: l10n.scheduledStartTime,
            selectedDateTime: _scheduledStartTime,
            onDateTimeChanged: (dateTime) {
              setState(() {
                _scheduledStartTime = dateTime;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildMaxDurationField(l10n),
          const SizedBox(height: 16),
          _buildMaxParticipantsField(l10n),
          const SizedBox(height: 32),
          _buildSubmitButton(l10n),
        ],
      ),
    );
  }

  Widget _buildTitleField(AppLocalizations l10n) {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: l10n.conferenceTitle,
        hintText: l10n.enterConferenceTitle ?? 'Enter conference title',
        prefixIcon: const Icon(Icons.title),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.pleaseEnterTitle ?? 'Please enter a title';
        }
        if (value.trim().length < 3) {
          return l10n.titleMinLength ?? 'Title must be at least 3 characters';
        }
        return null;
      },
      enabled: !widget.isLoading,
    );
  }

  Widget _buildDescriptionField(AppLocalizations l10n) {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: l10n.conferenceDescription,
        hintText:
            l10n.enterConferenceDescription ?? 'Enter conference description',
        prefixIcon: const Icon(Icons.description),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      maxLines: 4,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.pleaseEnterDescription ?? 'Please enter a description';
        }
        if (value.trim().length < 10) {
          return l10n.descriptionMinLength ??
              'Description must be at least 10 characters';
        }
        return null;
      },
      enabled: !widget.isLoading,
    );
  }

  Widget _buildPriceField(AppLocalizations l10n) {
    return TextFormField(
      controller: _priceController,
      decoration: InputDecoration(
        labelText: l10n.conferencePrice,
        hintText: '0',
        prefixIcon: const Icon(Icons.monetization_on),
        suffixText: 'IQD',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterPrice ?? 'Please enter a price';
        }
        final price = double.tryParse(value);
        if (price == null || price < 0) {
          return l10n.pleaseEnterValidPrice ?? 'Please enter a valid price';
        }
        return null;
      },
      enabled: !widget.isLoading,
    );
  }

  Widget _buildMaxDurationField(AppLocalizations l10n) {
    return TextFormField(
      controller: _maxDurationController,
      decoration: InputDecoration(
        labelText: l10n.maxDuration,
        hintText: '60',
        prefixIcon: const Icon(Icons.timer),
        suffixText: l10n.minutes ?? 'minutes',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterMaxDuration ?? 'Please enter max duration';
        }
        final duration = int.tryParse(value);
        if (duration == null || duration < 15 || duration > 300) {
          return l10n.durationRange ??
              'Duration must be between 15 and 300 minutes';
        }
        return null;
      },
      enabled: !widget.isLoading,
    );
  }

  Widget _buildMaxParticipantsField(AppLocalizations l10n) {
    return TextFormField(
      controller: _maxParticipantsController,
      decoration: InputDecoration(
        labelText: l10n.maxParticipants,
        hintText: '50',
        prefixIcon: const Icon(Icons.people),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return l10n.pleaseEnterMaxParticipants ??
              'Please enter max participants';
        }
        final participants = int.tryParse(value);
        if (participants == null || participants < 2 || participants > 500) {
          return l10n.participantsRange ??
              'Participants must be between 2 and 500';
        }
        return null;
      },
      enabled: !widget.isLoading,
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return SizedBox(
      height: 50,
      child: ElevatedButton.icon(
        onPressed: widget.isLoading ? null : _handleSubmit,
        icon: widget.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.add),
        label: Text(
          l10n.createConference,
          style: const TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if scheduled time is in the future
    if (_scheduledStartTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.scheduledTimeFuture ??
                'Scheduled time must be in the future',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authBloc = context.read<AuthBloc>();
    final user = authBloc.state.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.userNotAuthenticated ??
                'User not authenticated',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final params = CreateConferenceParams(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      instructorId: user.id,
      instructorName: user.name,
      price: double.parse(_priceController.text),
      scheduledStartTime: _scheduledStartTime,
      maxDuration: int.parse(_maxDurationController.text),
      maxParticipants: int.parse(_maxParticipantsController.text),
    );

    context.read<LiveConferenceBloc>().add(CreateConferenceRequested(params));
  }
}
