import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/message_service.dart';
import '../models/message_model.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUsername;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.otherUsername,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController =
      TextEditingController();

  final MessageService _messageService = MessageService();

  final List<String> messages = [];

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) {
      return;
    }

    final message = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: FirebaseAuth.instance.currentUser?.uid ?? 'currentUser',
      receiverId: widget.otherUserId,
      content: messageController.text.trim(),
      messageType: 'text',
      isSeen: false,
      sentAt: DateTime.now(),
    );

    await _messageService.sendMessage(
  receiverId: widget.otherUserId,
  text: message.content,
);

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && widget.otherUserId.isNotEmpty) {
      try {
        final notification = NotificationModel(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          receiverId: widget.otherUserId,
          senderId: currentUser.uid,
          type: 'message',
          title: 'New message',
          body: message.content,
          isRead: false,
          createdAt: DateTime.now(),
        );

        await NotificationService().createNotification(notification);
      } catch (_) {}
    }

    setState(() {
      messages.add(message.content);
    });

    messageController.clear();
  }

  @override
Widget build(BuildContext context) {
  final currentUserId =
      FirebaseAuth.instance.currentUser?.uid ?? 'currentUser';

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.otherUsername),
      centerTitle: true,
    ),
    body: Column(
      children: [
        Expanded(
          child: StreamBuilder<List<MessageModel>>(
            stream: _messageService.getMessages(
              currentUserId,
              widget.otherUserId,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'حدث خطأ في تحميل الرسائل',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              final firestoreMessages = snapshot.data ?? [];

              if (firestoreMessages.isEmpty) {
                return const Center(
                  child: Text(
                    'لا توجد رسائل بعد',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: firestoreMessages.length,
                itemBuilder: (context, index) {
                  final message = firestoreMessages[index];
                  final isMine = message.senderId == currentUserId;

                  if (!isMine && !message.isSeen) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _messageService.markAsSeen(message.id);
                    });
                  }

                  return Align(
                    alignment: isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: GestureDetector(
                      onLongPress: isMine
                          ? () async {
                              final shouldDelete =
                                  await showDialog<bool>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('حذف الرسالة'),
                                    content: const Text(
                                      'هل تريد حذف هذه الرسالة؟',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('إلغاء'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('حذف'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (shouldDelete == true) {
                                await _messageService.deleteMessage(
                                  message.id,
                                );
                              }
                            }
                          : null,
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isMine
                            ? Colors.blue
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: isMine ? Colors.white : Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'اكتب رسالة',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

@override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}
