class PostModel {
  final String id;
  final String ownerId;
  final String ownerUsername;
  final String ownerPhoto;
  final String caption;
  final List<String> mediaUrls;
  final String mediaType;
  final List<String> likes;
  final int commentsCount;
  final int sharesCount;
  final int viewsCount;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.ownerId,
    required this.ownerUsername,
    required this.ownerPhoto,
    required this.caption,
    required this.mediaUrls,
    required this.mediaType,
    required this.likes,
    required this.commentsCount,
    required this.sharesCount,
    required this.viewsCount,
    required this.createdAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerUsername: map['ownerUsername'] ?? '',
      ownerPhoto: map['ownerPhoto'] ?? '',
      caption: map['caption'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      mediaType: map['mediaType'] ?? '',
      likes: List<String>.from(map['likes'] ?? []),
      commentsCount: map['commentsCount'] ?? 0,
      sharesCount: map['sharesCount'] ?? 0,
      viewsCount: map['viewsCount'] ?? 0,
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerUsername': ownerUsername,
      'ownerPhoto': ownerPhoto,
      'caption': caption,
      'mediaUrls': mediaUrls,
      'mediaType': mediaType,
      'likes': likes,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'viewsCount': viewsCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
