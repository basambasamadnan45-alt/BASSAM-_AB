import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import 'notification_service.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection('posts');

  Future<void> createPost({
    required String text,
    String? imageUrl,
    required String userId,
    required String username,
    String? ownerPhoto,
    String mediaType = 'text',
  }) async {
    final postRef = _posts.doc();

    await postRef.set({
      'id': postRef.id,
      'ownerId': userId,
      'ownerUsername': username,
      'ownerPhoto': ownerPhoto ?? '',
      'caption': text.trim(),
      'mediaUrls': imageUrl != null && imageUrl.trim().isNotEmpty
          ? [imageUrl.trim()]
          : <String>[],
      'mediaType': mediaType,
      'likes': <String>[],
      'commentsCount': 0,
      'sharesCount': 0,
      'viewsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore
        .collection('users')
        .doc(userId)
        .update({
      'postsCount': FieldValue.increment(1),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    return _posts
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> likePost({
    required String postId,
    required String userId,
  }) async {
    final postRef = _posts.doc(postId);
    final postSnapshot = await postRef.get();

    if (!postSnapshot.exists) return;

    final data = postSnapshot.data() ?? <String, dynamic>{};
    final ownerId = data['ownerId']?.toString() ?? '';
    final likes = List<String>.from(data['likes'] ?? <String>[]);

    // Prevent duplicate likes and duplicate like notifications.
    if (likes.contains(userId)) return;

    await postRef.update({
      'likes': FieldValue.arrayUnion([userId]),
    });

    // Do not notify a user about their own like.
    if (ownerId.isEmpty || ownerId == userId) return;

    try {
      final notification = NotificationModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        receiverId: ownerId,
        senderId: userId,
        type: 'like',
        title: 'New like',
        body: 'Someone liked your post on Connect AB.',
        isRead: false,
      postId: postId,
        createdAt: DateTime.now(),
      );

      await NotificationService().createNotification(notification);
    } catch (_) {}
  }

  Future<void> unlikePost({
    required String postId,
    required String userId,
  }) async {
    await _posts.doc(postId).update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  Future<void> incrementViews(String postId) async {
    await _posts.doc(postId).update({
      'viewsCount': FieldValue.increment(1),
    });
  }

  Future<void> incrementShares(String postId) async {
    await _posts.doc(postId).update({
      'sharesCount': FieldValue.increment(1),
    });
  }

  Future<void> deletePost(String postId) async {
    await _posts.doc(postId).delete();
  }

  Future<void> savePost({
    required String postId,
    required String userId,
  }) async {
    await _firestore
        .collection('saved_posts')
        .doc(userId)
        .collection('posts')
        .doc(postId)
        .set({
      'postId': postId,
      'userId': userId,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unsavePost({
    required String postId,
    required String userId,
  }) async {
    await _firestore
        .collection('saved_posts')
        .doc(userId)
        .collection('posts')
        .doc(postId)
        .delete();
  }

  Future<bool> isPostSaved({
    required String postId,
    required String userId,
  }) async {
    final doc = await _firestore
        .collection('saved_posts')
        .doc(userId)
        .collection('posts')
        .doc(postId)
        .get();

    return doc.exists;
  }

}
