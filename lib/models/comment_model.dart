class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String username;
  final String userPhoto;
  final String content;
  final List<String> likes;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.username,
    required this.userPhoto,
    required this.content,
    required this.likes,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      userPhoto: map['userPhoto'] ?? '',
      content: map['content'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'userId': userId,
      'username': username,
      'userPhoto': userPhoto,
      'content': content,
      'likes': likes,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
