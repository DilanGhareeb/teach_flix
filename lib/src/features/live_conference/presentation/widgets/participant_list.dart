import 'package:flutter/material.dart';
import 'package:teach_flix/src/features/live_conference/data/services/conference_participant_sync.dart';

/// Enhanced participants panel with real names and statuses
class ParticipantList extends StatelessWidget {
  final List<ParticipantData> participants;
  final int localUid;
  final bool isInstructor;
  final VoidCallback onClose;

  const ParticipantList({
    super.key,
    required this.participants,
    required this.localUid,
    required this.isInstructor,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // Sort: Instructor first, then alphabetically
    final sortedParticipants = List<ParticipantData>.from(participants)
      ..sort((a, b) {
        if (a.isInstructor && !b.isInstructor) return -1;
        if (!a.isInstructor && b.isInstructor) return 1;
        return a.userName.compareTo(b.userName);
      });

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Participants (${participants.length})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  iconSize: 20,
                ),
              ],
            ),
          ),

          // Participants list
          Expanded(
            child: participants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 48,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No participants yet',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: sortedParticipants.length,
                    itemBuilder: (context, index) {
                      final participant = sortedParticipants[index];
                      final isYou = participant.agoraUid == localUid;

                      return _ParticipantTile(
                        participant: participant,
                        isYou: isYou,
                      );
                    },
                  ),
          ),

          // Footer with invite button (if instructor)
          if (isInstructor)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.white.withOpacity(0.1)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Implement invite functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invite feature coming soon!'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.person_add),
                    label: const Text('Invite'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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

class _ParticipantTile extends StatelessWidget {
  final ParticipantData participant;
  final bool isYou;

  const _ParticipantTile({required this.participant, required this.isYou});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isYou ? Colors.white.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: participant.isInstructor
            ? Border.all(color: Colors.orange.withOpacity(0.5), width: 1)
            : null,
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: participant.isInstructor
                    ? Colors.orange
                    : Colors.blue,
                child: Text(
                  participant.userName.isNotEmpty
                      ? participant.userName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Online indicator
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF2C2C2E),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Name and role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        participant.userName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isYou) ...[
                      const SizedBox(width: 4),
                      Text(
                        '(You)',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                if (participant.isInstructor)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'HOST',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Status indicators
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (participant.isMuted)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mic_off, color: Colors.red, size: 14),
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.mic, color: Colors.green[400], size: 14),
                ),
              const SizedBox(width: 6),
              if (!participant.hasVideo)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.videocam_off,
                    color: Colors.red,
                    size: 14,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.videocam,
                    color: Colors.green[400],
                    size: 14,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
