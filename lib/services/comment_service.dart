import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/comment_model.dart';

class CommentService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _comments(
    String postId,
  ) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments');
  }

  Future<void> addComment({
    required String postId,
    required String userId,
    required String username,
    required String userPhoto,
    required String text,
  }) async {
    final ref = _comments(postId).doc();

    final comment = CommentModel(
      id: ref.id,
      postId: postId,
      userId: userId,
      username: username,
      userPhoto: userPhoto,
      text: text.trim(),
      createdAt: DateTime.now(),
      likes: const [],
    );

    await ref.set(comment.toMap());

    await _firestore.collection('posts').doc(postId).update({
      'commentsCount': FieldValue.increment(1),
    });
  }

  Stream<List<CommentModel>> getComments(String postId) {
    return _comments(postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CommentModel.fromMap(doc.data()))
              .toList(),
        );
  }

  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    await _comments(postId).doc(commentId).delete();

    await _firestore.collection('posts').doc(postId).update({
      'commentsCount': FieldValue.increment(-1),
    });
  }

  Future<void> likeComment({
    required String postId,
    required String commentId,
    required String userId,
  }) async {
    await _comments(postId).doc(commentId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> unlikeComment({
    required String postId,
    required String commentId,
    required String userId,
  }) async {
    await _comments(postId).doc(commentId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }
}
