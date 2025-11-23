import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:teach_flix/src/features/ai_assistnat/data/models/chat_session_model.dart';
import 'package:teach_flix/src/features/ai_assistnat/data/models/message_model.dart';
import 'package:teach_flix/src/features/ai_assistnat/domain/entities/message.dart';
import 'package:uuid/uuid.dart';

abstract class AiChatRemoteDataSource {
  Future<MessageModel> sendMessage({
    required String sessionId,
    required String userId,
    required String text,
  });

  Future<MessageModel> sendMessageWithMedia({
    required String sessionId,
    required String userId,
    required String text,
    required String filePath,
    required MessageType messageType,
  });

  Stream<List<MessageModel>> watchMessages(String sessionId);

  Future<ChatSessionModel> createChatSession({
    required String userId,
    required String title,
  });

  Stream<List<ChatSessionModel>> watchChatSessions(String userId);

  Future<void> deleteChatSession(String sessionId);

  Future<void> updateChatSessionTitle({
    required String sessionId,
    required String title,
  });

  Future<void> clearMessages(String sessionId);

  // NEW: Streaming AI response
  Stream<String> getAiResponseStream({
    required String sessionId,
    required String userId,
    required String message,
    List<MessageModel>? conversationHistory,
  });

  Stream<String> getAiResponseWithImageStream({
    required String sessionId,
    required String userId,
    required String message,
    required String imagePath,
    List<MessageModel>? conversationHistory,
  });
}

class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});
}

class AiChatRemoteDataSourceImpl implements AiChatRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  final GenerativeModel geminiModel;

  AiChatRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
    required this.geminiModel,
  });

  @override
  Future<MessageModel> sendMessage({
    required String sessionId,
    required String userId,
    required String text,
  }) async {
    try {
      final messageId = const Uuid().v4();
      final now = DateTime.now();

      final userMessage = MessageModel(
        id: messageId,
        text: text,
        authorId: userId,
        createdAt: now,
        type: MessageType.text,
        status: MessageStatus.sending,
      );

      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .doc(messageId)
          .set(userMessage.toFirestore());

      await _updateChatSession(sessionId, text, now);

      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .doc(messageId)
          .update({'status': MessageStatus.sent.name});

      // Create AI message placeholder
      final aiMessageId = const Uuid().v4();
      final aiMessage = MessageModel(
        id: aiMessageId,
        text: '',
        authorId: 'ai',
        createdAt: DateTime.now(),
        type: MessageType.text,
        status: MessageStatus.sending,
      );

      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .doc(aiMessageId)
          .set(aiMessage.toFirestore());

      // Stream AI response
      final conversationHistory = await _getConversationHistory(sessionId);
      final fullResponse = StringBuffer();

      await for (final chunk in getAiResponseStream(
        sessionId: sessionId,
        userId: userId,
        message: text,
        conversationHistory: conversationHistory,
      )) {
        fullResponse.write(chunk);

        // Update AI message in real-time
        await firestore
            .collection('chat_sessions')
            .doc(sessionId)
            .collection('messages')
            .doc(aiMessageId)
            .update({
              'text': fullResponse.toString(),
              'status': MessageStatus.sending.name,
            });
      }

      // Mark as complete
      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .doc(aiMessageId)
          .update({'status': MessageStatus.sent.name});

      await _updateChatSession(
        sessionId,
        fullResponse.toString(),
        DateTime.now(),
      );

      return userMessage.copyWith(status: MessageStatus.sent) as MessageModel;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<MessageModel> sendMessageWithMedia({
    required String sessionId,
    required String userId,
    required String text,
    required String filePath,
    required MessageType messageType,
  }) async {
    try {
      final messageId = const Uuid().v4();
      final now = DateTime.now();
      final file = File(filePath);
      final fileName = file.path.split('/').last;

      print('📤 Starting media upload...');
      print('   Message ID: $messageId');
      print('   File: $fileName');
      print('   Type: ${messageType.name}');

      final userMessage = MessageModel(
        id: messageId,
        text: text,
        authorId: userId,
        createdAt: now,
        type: messageType,
        status: MessageStatus.sending,
        mediaName: fileName,
        mediaSize: await file.length(),
      );

      // Save initial message
      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .doc(messageId)
          .set(userMessage.toFirestore());

      print('✅ Message saved to Firestore');

      // Upload to storage
      final storageRef = storage.ref().child(
        'chat_media/$sessionId/$messageId/$fileName',
      );

      print('⬆️  Uploading to Firebase Storage...');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      print('✅ Upload complete: $downloadUrl');

      // Update message with media URL
      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .doc(messageId)
          .update({'status': MessageStatus.sent.name, 'mediaUrl': downloadUrl});

      await _updateChatSession(
        sessionId,
        text.isEmpty ? 'Sent ${messageType.name}' : text,
        now,
      );

      // If it's an image, get AI response with image analysis (streaming)
      if (messageType == MessageType.image) {
        print('🤖 Requesting AI analysis of image...');
        final conversationHistory = await _getConversationHistory(sessionId);

        final promptText = text.isEmpty
            ? 'What do you see in this image? Please describe it in detail.'
            : text;

        // Create AI message placeholder
        final aiMessageId = const Uuid().v4();
        final aiMessage = MessageModel(
          id: aiMessageId,
          text: '',
          authorId: 'ai',
          createdAt: DateTime.now(),
          type: MessageType.text,
          status: MessageStatus.sending,
        );

        await firestore
            .collection('chat_sessions')
            .doc(sessionId)
            .collection('messages')
            .doc(aiMessageId)
            .set(aiMessage.toFirestore());

        // Stream AI response
        final fullResponse = StringBuffer();

        await for (final chunk in getAiResponseWithImageStream(
          sessionId: sessionId,
          userId: userId,
          message: promptText,
          imagePath: filePath,
          conversationHistory: conversationHistory,
        )) {
          fullResponse.write(chunk);

          // Update AI message in real-time
          await firestore
              .collection('chat_sessions')
              .doc(sessionId)
              .collection('messages')
              .doc(aiMessageId)
              .update({
                'text': fullResponse.toString(),
                'status': MessageStatus.sending.name,
              });
        }

        // Mark as complete
        await firestore
            .collection('chat_sessions')
            .doc(sessionId)
            .collection('messages')
            .doc(aiMessageId)
            .update({'status': MessageStatus.sent.name});

        await _updateChatSession(
          sessionId,
          fullResponse.toString(),
          DateTime.now(),
        );

        print('✅ AI response complete');
      }

      return MessageModel(
        id: messageId,
        text: text,
        authorId: userId,
        createdAt: now,
        type: messageType,
        status: MessageStatus.sent,
        mediaUrl: downloadUrl,
        mediaName: fileName,
        mediaSize: await file.length(),
      );
    } on FirebaseException catch (e) {
      print('❌ Firebase error: ${e.message}');
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    } catch (e) {
      print('❌ Error in sendMessageWithMedia: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<MessageModel>> watchMessages(String sessionId) {
    try {
      return firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => MessageModel.fromFirestore(doc))
                .toList();
          });
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    }
  }

  @override
  Future<ChatSessionModel> createChatSession({
    required String userId,
    required String title,
  }) async {
    try {
      final sessionId = const Uuid().v4();
      final now = DateTime.now();

      final session = ChatSessionModel(
        id: sessionId,
        userId: userId,
        title: title,
        createdAt: now,
        updatedAt: now,
        messageCount: 0,
      );

      await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .set(session.toFirestore());

      return session;
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Stream<List<ChatSessionModel>> watchChatSessions(String userId) {
    try {
      return firestore
          .collection('chat_sessions')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => ChatSessionModel.fromFirestore(doc))
                .toList();
          });
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    }
  }

  @override
  Future<void> deleteChatSession(String sessionId) async {
    try {
      print('🗑️  Deleting session: $sessionId');

      // Delete all messages
      final messagesSnapshot = await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .get();

      print('📝 Found ${messagesSnapshot.docs.length} messages to delete');

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the session
      await firestore.collection('chat_sessions').doc(sessionId).delete();
      print('✅ Session deleted from Firestore');

      // Try to delete storage files
      try {
        final storageRef = storage.ref().child('chat_media/$sessionId');
        final listResult = await storageRef.listAll();

        print('📁 Found ${listResult.items.length} storage items to delete');

        for (var item in listResult.items) {
          await item.delete();
        }
        print('✅ Storage files deleted');
      } catch (e) {
        print('⚠️  Storage deletion warning: $e');
        // Ignore storage errors - files might not exist
      }
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateChatSessionTitle({
    required String sessionId,
    required String title,
  }) async {
    try {
      print('✏️  Updating session title: $sessionId -> $title');
      await firestore.collection('chat_sessions').doc(sessionId).update({
        'title': title,
        'updatedAt': Timestamp.now(),
      });
      print('✅ Title updated successfully');
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> clearMessages(String sessionId) async {
    try {
      print('🧹 Clearing messages for session: $sessionId');

      final messagesSnapshot = await firestore
          .collection('chat_sessions')
          .doc(sessionId)
          .collection('messages')
          .get();

      print('📝 Found ${messagesSnapshot.docs.length} messages to clear');

      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      await firestore.collection('chat_sessions').doc(sessionId).update({
        'lastMessageText': null,
        'messageCount': 0,
        'updatedAt': Timestamp.now(),
      });

      print('✅ Messages cleared successfully');
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase error occurred');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  // NEW: Streaming AI response
  @override
  Stream<String> getAiResponseStream({
    required String sessionId,
    required String userId,
    required String message,
    List<MessageModel>? conversationHistory,
  }) async* {
    try {
      print('🤖 AI Streaming Request - Starting...');
      print('📝 Message: $message');

      final prompt = _buildPrompt(message, conversationHistory);
      print('📋 Prompt built successfully');

      print('🔄 Calling Gemini API with streaming...');

      final response = geminiModel.generateContentStream([
        Content.text(prompt),
      ]);

      await for (final chunk in response) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          print(
            '📦 Chunk received: ${chunk.text!.substring(0, chunk.text!.length.clamp(0, 20))}...',
          );
          yield chunk.text!;
        }
      }

      print('✅ AI Streaming complete');
    } catch (e, stackTrace) {
      print('❌ AI Streaming Error: $e');
      print('📚 Stack trace: $stackTrace');
      throw ServerException(message: 'AI streaming error: ${e.toString()}');
    }
  }

  @override
  Stream<String> getAiResponseWithImageStream({
    required String sessionId,
    required String userId,
    required String message,
    required String imagePath,
    List<MessageModel>? conversationHistory,
  }) async* {
    try {
      print('🤖 AI Streaming Request with Image - Starting...');
      print('📝 Message: $message');
      print('🖼️  Image: $imagePath');

      // Read image file
      final file = File(imagePath);
      final Uint8List imageBytes = await file.readAsBytes();

      print('✅ Image loaded: ${imageBytes.length} bytes');

      // Build prompt with conversation history
      final contextPrompt =
          conversationHistory != null && conversationHistory.isNotEmpty
          ? _buildPrompt(message, conversationHistory)
          : message;

      print('🔄 Calling Gemini API with image streaming...');

      // Create content with both text and image
      final response = geminiModel.generateContentStream([
        Content.multi([
          TextPart(contextPrompt),
          InlineDataPart('image/jpeg', imageBytes),
        ]),
      ]);

      await for (final chunk in response) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          print(
            '📦 Image chunk received: ${chunk.text!.substring(0, chunk.text!.length.clamp(0, 20))}...',
          );
          yield chunk.text!;
        }
      }

      print('✅ AI Image Streaming complete');
    } catch (e, stackTrace) {
      print('❌ AI Streaming Error with Image: $e');
      print('📚 Stack trace: $stackTrace');
      throw ServerException(
        message: 'AI streaming error with image: ${e.toString()}',
      );
    }
  }

  Future<void> _updateChatSession(
    String sessionId,
    String lastMessage,
    DateTime updatedAt,
  ) async {
    await firestore.collection('chat_sessions').doc(sessionId).update({
      'lastMessageText': lastMessage,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'messageCount': FieldValue.increment(1),
    });
  }

  Future<List<MessageModel>> _getConversationHistory(String sessionId) async {
    final snapshot = await firestore
        .collection('chat_sessions')
        .doc(sessionId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(20)
        .get();

    return snapshot.docs
        .map((doc) => MessageModel.fromFirestore(doc))
        .toList()
        .reversed
        .toList();
  }

  String _buildPrompt(String message, List<MessageModel>? conversationHistory) {
    if (conversationHistory == null || conversationHistory.isEmpty) {
      return message;
    }

    final buffer = StringBuffer();
    buffer.writeln('Previous conversation:');

    for (var msg in conversationHistory.take(10)) {
      final role = msg.authorId == 'ai' ? 'Assistant' : 'User';
      buffer.writeln('$role: ${msg.text}');
    }

    buffer.writeln('\nCurrent message:');
    buffer.writeln('User: $message');
    buffer.writeln('\nProvide a helpful response:');

    return buffer.toString();
  }
}
