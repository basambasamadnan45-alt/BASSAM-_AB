
class UserModel {
  final String uid;
  final String username;
  final String displayName;
  final String email;
  final String photoUrl;
  final String bio;
  final List<String> followers;
  final List<String> following;
  final int postsCount;
  final bool isVerified;
  final bool isPrivate;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.postsCount,
    required this.isVerified,
    required this.isPrivate,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      displayName: map['displayName'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      bio: map['bio'] ?? '',
      followers: List<String>.from(map['followers'] ?? []),
      following: List<String>.from(map['following'] ?? []),
      postsCount: map['postsCount'] ?? 0,
      isVerified: map['isVerified'] ?? false,
      isPrivate: map['isPrivate'] ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'bio': bio,
      'followers': followers,
      'following': following,
      'postsCount': postsCount,
      'isVerified': isVerified,
      'isPrivate': isPrivate,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
