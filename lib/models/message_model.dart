class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final String messageType;
  final bool isSeen;
  final DateTime sentAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.messageType,
    required this.isSeen,
    required this.sentAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      content: map['content'] ?? '',
      messageType: map['messageType'] ?? 'text',
      isSeen: map['isSeen'] ?? false,
      sentAt: DateTime.tryParse(map['sentAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'messageType': messageType,
      'isSeen': isSeen,
      'sentAt': sentAt.toIso8601String(),
    };
  }
}
