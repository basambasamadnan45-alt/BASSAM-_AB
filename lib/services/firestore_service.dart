import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  Future<void> createUserProfile({
    required User user,
    required String name,
    String? username,
  }) async {
    final safeUsername = (username ?? name)
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_');

    await _users.doc(user.uid).set({
      'uid': user.uid,
      'username': safeUsername,
      'displayName': name.trim(),
      'name': name.trim(),
      'email': user.email ?? '',
      'photoUrl': '',
      'bio': '',
      'followers': <String>[],
      'following': <String>[],
      'postsCount': 0,
      'isVerified': false,
      'isPrivate': false,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(
    String uid,
  ) async {
    return _users.doc(uid).get();
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _users.doc(uid).update(data);
  }

  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    if (currentUserId == targetUserId) return;

    final currentUserRef = _users.doc(currentUserId);
    final targetUserRef = _users.doc(targetUserId);

    await _firestore.runTransaction((transaction) async {
      final currentSnapshot = await transaction.get(currentUserRef);
      final targetSnapshot = await transaction.get(targetUserRef);

      final currentData = currentSnapshot.data() ?? {};
      final targetData = targetSnapshot.data() ?? {};

      final following = List<String>.from(
        currentData['following'] ?? <String>[],
      );

      final followers = List<String>.from(
        targetData['followers'] ?? <String>[],
      );

      if (!following.contains(targetUserId)) {
        following.add(targetUserId);
      }

      if (!followers.contains(currentUserId)) {
        followers.add(currentUserId);
      }

      transaction.update(currentUserRef, {
        'following': following,
      });

      transaction.update(targetUserRef, {
        'followers': followers,
      });
    });
  }

  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
  }) async {
    if (currentUserId == targetUserId) return;

    final currentUserRef = _users.doc(currentUserId);
    final targetUserRef = _users.doc(targetUserId);

    await _firestore.runTransaction((transaction) async {
      final currentSnapshot = await transaction.get(currentUserRef);
      final targetSnapshot = await transaction.get(targetUserRef);

      final currentData = currentSnapshot.data() ?? {};
      final targetData = targetSnapshot.data() ?? {};

      final following = List<String>.from(
        currentData['following'] ?? <String>[],
      );

      final followers = List<String>.from(
        targetData['followers'] ?? <String>[],
      );

      following.remove(targetUserId);
      followers.remove(currentUserId);

      transaction.update(currentUserRef, {
        'following': following,
      });

      transaction.update(targetUserRef, {
        'followers': followers,
      });
    });
  }

  Future<void> incrementPostsCount(String uid) async {
    await _users.doc(uid).update({
      'postsCount': FieldValue.increment(1),
    });
  }

  Future<void> decrementPostsCount(String uid) async {
    await _users.doc(uid).update({
      'postsCount': FieldValue.increment(-1),
    });
  }
}
