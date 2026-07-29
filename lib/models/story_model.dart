class StoryModel {
  final String id;
  final String ownerId;
  final String ownerUsername;
  final String ownerPhoto;
  final String mediaUrl;
  final String mediaType;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewers;
  final List<String> reactions;

  StoryModel({
    required this.id,
    required this.ownerId,
    required this.ownerUsername,
    required this.ownerPhoto,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
    required this.expiresAt,
    required this.viewers,
    required this.reactions,
  });

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'] ?? '',
      ownerId: map['ownerId'] ?? '',
      ownerUsername: map['ownerUsername'] ?? '',
      ownerPhoto: map['ownerPhoto'] ?? '',
      mediaUrl: map['mediaUrl'] ?? '',
      mediaType: map['mediaType'] ?? 'image',
      createdAt:
          DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      expiresAt:
          DateTime.tryParse(map['expiresAt'] ?? '') ??
          DateTime.now().add(const Duration(hours: 24)),
      viewers: List<String>.from(map['viewers'] ?? []),
      reactions: List<String>.from(map['reactions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerUsername': ownerUsername,
      'ownerPhoto': ownerPhoto,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'viewers': viewers,
      'reactions': reactions,
    };
  }
}
