import 'package:cloud_firestore/cloud_firestore.dart';

class PostService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  Future<void> createPost({
    required String text,
    String? imageUrl,
    required String userId,
    required String username,
  }) async {
    await _firestore.collection('posts').add({
      'text': text,
      'imageUrl': imageUrl ?? '',
      'userId': userId,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
      'likes': 0,
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }
}
