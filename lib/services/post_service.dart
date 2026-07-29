import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPost(PostModel post) async {
    await _firestore
        .collection('posts')
        .doc(post.id)
        .set(post.toMap());
  }

  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> likePost(String postId, List<String> likes) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .update({
      'likes': likes,
    });
  }

  Future<void> deletePost(String postId) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .delete();
  }
}
