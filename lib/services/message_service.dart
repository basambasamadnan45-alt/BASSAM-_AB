import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    await _firestore
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());
  }

  Stream<List<MessageModel>> getMessages(
    String userId,
    String otherUserId,
  ) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [userId, otherUserId])
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MessageModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> markAsSeen(String messageId) async {
    await _firestore
        .collection('messages')
        .doc(messageId)
        .update({
      'isSeen': true,
    });
  }

  Future<void> deleteMessage(String messageId) async {
    await _firestore
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
