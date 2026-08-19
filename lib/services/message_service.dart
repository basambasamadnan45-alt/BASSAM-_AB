import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/message_model.dart';

class MessageService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String get _currentUserId {
    final user = auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    return user.uid;
  }

  String get _currentUserIdSafe {
    return auth.currentUser?.uid ?? '';
  }

  String getConversationId(String user1, String user2) {
    final users = [user1, user2]..sort();
    return '${users[0]}_${users[1]}';
  }

  Future<void> sendMessage({
    required String receiverId,
    required String text,
  }) async {
    final messageText = text.trim();

    if (messageText.isEmpty) return;

    final senderId = _currentUserId;

    final conversationId =
        getConversationId(senderId, receiverId);

    final conversationRef =
        firestore.collection('conversations').doc(conversationId);

    final messageRef =
        conversationRef.collection('messages').doc();

    await messageRef.set({
      'id': messageRef.id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': messageText,
      'messageType': 'text',
      'isSeen': false,
      'sentAt': FieldValue.serverTimestamp(),
    });

    await conversationRef.set({
      'participants': [
        senderId,
        receiverId,
      ],
      'lastMessage': messageText,
      'lastMessageSenderId': senderId,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Stream<List<MessageModel>> getMessages(
    String currentUserId,
    String otherUserId,
  ) {
    final conversationId =
        getConversationId(currentUserId, otherUserId);

    return firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        final sentAtValue = data['sentAt'];

        DateTime sentAt = DateTime.now();

        if (sentAtValue is Timestamp) {
          sentAt = sentAtValue.toDate();
        } else if (sentAtValue is String) {
          sentAt =
              DateTime.tryParse(sentAtValue) ?? DateTime.now();
        }

        return MessageModel(
          id: doc.id,
          senderId: data['senderId']?.toString() ?? '',
          receiverId: data['receiverId']?.toString() ?? '',
          content: data['content']?.toString() ??
              data['text']?.toString() ??
              '',
          messageType: data['messageType']?.toString() ??
              data['type']?.toString() ??
              'text',
          isSeen: data['isSeen'] == true,
          sentAt: sentAt,
        );
      }).toList();
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> messagesStream(
    String otherUserId,
  ) {
    final conversationId =
        getConversationId(_currentUserId, otherUserId);

    return firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('sentAt', descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conversationsStream() {
    final currentUserId = _currentUserIdSafe;

    if (currentUserId.isEmpty) {
      return const Stream.empty();
    }

    return firestore
        .collection('conversations')
        .where(
          'participants',
          arrayContains: currentUserId,
        )
        .orderBy(
          'updatedAt',
          descending: true,
        )
        .snapshots();
  }

  Future<void> markAsSeen(String messageId) async {
    final currentUserId = _currentUserId;

    final conversationsSnapshot = await firestore
        .collection('conversations')
        .where(
          'participants',
          arrayContains: currentUserId,
        )
        .get();

    for (final conversation in conversationsSnapshot.docs) {
      final messageRef = conversation.reference
          .collection('messages')
          .doc(messageId);

      final messageSnapshot = await messageRef.get();

      if (!messageSnapshot.exists) {
        continue;
      }

      final data = messageSnapshot.data();

      if (data == null) {
        continue;
      }

      if (data['receiverId'] == currentUserId &&
          data['isSeen'] != true) {
        await messageRef.update({
          'isSeen': true,
        });
      }

      break;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final currentUserId = _currentUserId;

    final conversationsSnapshot = await firestore
        .collection('conversations')
        .where(
          'participants',
          arrayContains: currentUserId,
        )
        .get();

    for (final conversation in conversationsSnapshot.docs) {
      final messageRef = conversation.reference
          .collection('messages')
          .doc(messageId);

      final messageSnapshot = await messageRef.get();

      if (!messageSnapshot.exists) {
        continue;
      }

      final data = messageSnapshot.data();

      if (data == null) {
        continue;
      }

      if (data['senderId'] == currentUserId) {
        await messageRef.delete();
      }

      break;
    }
  }
}
