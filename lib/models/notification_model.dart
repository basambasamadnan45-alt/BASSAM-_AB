class NotificationModel {
  final String id;
  final String receiverId;
  final String senderId;
  final String type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? postId;
  final String? targetUserId;
  final String? chatId;

  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.postId,
    this.targetUserId,
    this.chatId,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      receiverId: map['receiverId'] ?? '',
      senderId: map['senderId'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt:
          DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      postId: map['postId']?.toString(),
      targetUserId: map['targetUserId']?.toString(),
      chatId: map['chatId']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiverId': receiverId,
      'senderId': senderId,
      'type': type,
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'postId': postId,
      'targetUserId': targetUserId,
      'chatId': chatId,
    };
  }
}
