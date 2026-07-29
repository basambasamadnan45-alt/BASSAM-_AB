import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/story_model.dart';

class StoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createStory(StoryModel story) async {
    await _firestore
        .collection('stories')
        .doc(story.id)
        .set(story.toMap());
  }

  Stream<List<StoryModel>> getStories() {
    return _firestore
        .collection('stories')
        .where(
          'expiresAt',
          isGreaterThan: DateTime.now().toIso8601String(),
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => StoryModel.fromMap(doc.data()))
          .toList();
    });
  }

  Future<void> addViewer(
    String storyId,
    List<String> viewers,
  ) async {
    await _firestore
        .collection('stories')
        .doc(storyId)
        .update({
      'viewers': viewers,
    });
  }

  Future<void> deleteStory(String storyId) async {
    await _firestore
        .collection('stories')
        .doc(storyId)
        .delete();
  }
}
