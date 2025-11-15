import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Participant data model with screen sharing support
class ParticipantData {
  final String userId;
  final String userName;
  final int agoraUid;
  final bool isInstructor;
  final bool isMuted;
  final bool hasVideo;
  final bool isSharingScreen;
  final DateTime? joinedAt;

  ParticipantData({
    required this.userId,
    required this.userName,
    required this.agoraUid,
    this.isInstructor = false,
    this.isMuted = false,
    this.hasVideo = true,
    this.isSharingScreen = false,
    this.joinedAt,
  });
}

/// Service to sync participant information via Firebase with screen sharing
class ConferenceParticipantSync {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Join conference and register participant info
  Future<void> joinConference({
    required String conferenceId,
    required String userId,
    required String userName,
    required int agoraUid,
    required bool isInstructor,
  }) async {
    try {
      await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .collection('participants')
          .doc(userId)
          .set({
            'userId': userId,
            'userName': userName,
            'agoraUid': agoraUid,
            'isInstructor': isInstructor,
            'joinedAt': FieldValue.serverTimestamp(),
            'isMuted': false,
            'hasVideo': true,
            'isSharingScreen': false,
            'isOnline': true,
          }, SetOptions(merge: true));

      debugPrint('[ParticipantSync] Joined: $userName (UID: $agoraUid)');
    } catch (e) {
      debugPrint('[ParticipantSync] Error joining: $e');
      rethrow;
    }
  }

  /// Leave conference
  Future<void> leaveConference({
    required String conferenceId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .collection('participants')
          .doc(userId)
          .update({
            'isOnline': false,
            'isSharingScreen': false,
            'leftAt': FieldValue.serverTimestamp(),
          });

      debugPrint('[ParticipantSync] Left conference');
    } catch (e) {
      debugPrint('[ParticipantSync] Error leaving: $e');
    }
  }

  /// Update participant status (mute/video/screen sharing)
  Future<void> updateStatus({
    required String conferenceId,
    required String userId,
    bool? isMuted,
    bool? hasVideo,
    bool? isSharingScreen,
  }) async {
    try {
      final Map<String, dynamic> updates = {};
      if (isMuted != null) updates['isMuted'] = isMuted;
      if (hasVideo != null) updates['hasVideo'] = hasVideo;
      if (isSharingScreen != null) {
        updates['isSharingScreen'] = isSharingScreen;
        updates['screenShareStartedAt'] = isSharingScreen
            ? FieldValue.serverTimestamp()
            : null;
      }

      if (updates.isNotEmpty) {
        await _firestore
            .collection('live_conferences')
            .doc(conferenceId)
            .collection('participants')
            .doc(userId)
            .update(updates);

        debugPrint('[ParticipantSync] Updated status: $updates');
      }
    } catch (e) {
      debugPrint('[ParticipantSync] Error updating status: $e');
    }
  }

  /// Watch participants in real-time
  Stream<List<ParticipantData>> watchParticipants(String conferenceId) {
    return _firestore
        .collection('live_conferences')
        .doc(conferenceId)
        .collection('participants')
        .where('isOnline', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ParticipantData(
              userId: data['userId'] as String,
              userName: data['userName'] as String,
              agoraUid: data['agoraUid'] as int,
              isInstructor: data['isInstructor'] as bool? ?? false,
              isMuted: data['isMuted'] as bool? ?? false,
              hasVideo: data['hasVideo'] as bool? ?? true,
              isSharingScreen: data['isSharingScreen'] as bool? ?? false,
              joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
            );
          }).toList();
        });
  }

  /// Get participant by Agora UID
  Future<ParticipantData?> getParticipantByAgoraUid({
    required String conferenceId,
    required int agoraUid,
  }) async {
    try {
      final snapshot = await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .collection('participants')
          .where('agoraUid', isEqualTo: agoraUid)
          .where('isOnline', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return ParticipantData(
          userId: data['userId'] as String,
          userName: data['userName'] as String,
          agoraUid: data['agoraUid'] as int,
          isInstructor: data['isInstructor'] as bool? ?? false,
          isMuted: data['isMuted'] as bool? ?? false,
          hasVideo: data['hasVideo'] as bool? ?? true,
          isSharingScreen: data['isSharingScreen'] as bool? ?? false,
          joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
        );
      }
      return null;
    } catch (e) {
      debugPrint('[ParticipantSync] Error getting participant: $e');
      return null;
    }
  }

  /// Check if anyone is currently sharing screen
  Future<bool> isAnyoneSharing(String conferenceId) async {
    try {
      final snapshot = await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .collection('participants')
          .where('isOnline', isEqualTo: true)
          .where('isSharingScreen', isEqualTo: true)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      debugPrint('[ParticipantSync] Error checking screen share: $e');
      return false;
    }
  }

  /// Get the participant who is sharing screen
  Future<ParticipantData?> getSharingParticipant(String conferenceId) async {
    try {
      final snapshot = await _firestore
          .collection('live_conferences')
          .doc(conferenceId)
          .collection('participants')
          .where('isOnline', isEqualTo: true)
          .where('isSharingScreen', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        return ParticipantData(
          userId: data['userId'] as String,
          userName: data['userName'] as String,
          agoraUid: data['agoraUid'] as int,
          isInstructor: data['isInstructor'] as bool? ?? false,
          isMuted: data['isMuted'] as bool? ?? false,
          hasVideo: data['hasVideo'] as bool? ?? true,
          isSharingScreen: true,
          joinedAt: (data['joinedAt'] as Timestamp?)?.toDate(),
        );
      }
      return null;
    } catch (e) {
      debugPrint('[ParticipantSync] Error getting sharing participant: $e');
      return null;
    }
  }
}
