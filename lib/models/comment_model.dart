class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String userPhoto;
  final String text;
  final DateTime createdAt;
  final List<String> likes;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userPhoto,
    required this.text,
    required this.createdAt,
    required this.likes,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userPhoto: map['userPhoto'] ?? '',
      text: map['text'] ?? '',
      createdAt: DateTime.tryParse(
            map['createdAt'] ?? '',
          ) ??
          DateTime.now(),
      likes: List<String>.from(
        map['likes'] ?? <String>[],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'userPhoto': userPhoto,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
    };
  }
}
