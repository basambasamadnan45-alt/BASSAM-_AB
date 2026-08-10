import 'package:cloud_firestore/cloud_firestore.dart';

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
    await _posts.doc(postId).update({
      'likes': FieldValue.arrayUnion([userId]),
    });
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
}
