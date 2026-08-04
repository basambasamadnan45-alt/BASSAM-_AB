import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required User user,
    required String name,
  }) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'email': user.email,
      'photoUrl': '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserProfile(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection('users').doc(uid).update(data);
  }
}
