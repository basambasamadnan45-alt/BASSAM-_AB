import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'comments_screen.dart';
import 'profile_screen.dart';

import '../models/notification_model.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text('يجب تسجيل الدخول أولاً'),
        ),
      );
    }

    final notificationService = NotificationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإشعارات'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<NotificationModel>>(
        stream: notificationService.getNotifications(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'حدث خطأ في تحميل الإشعارات',
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          final notifications = snapshot.data ?? [];

          if (notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'لا توجد إشعارات',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return Dismissible(
                key: ValueKey(notification.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
                onDismissed: (_) async {
                  await notificationService.deleteNotification(
                    notification.id,
                  );
                },
                child: Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: notification.isRead
                      ? null
                      : Color(0xFF7C4DFF).withValues(alpha: 0.08),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Icon(
                        notification.type == 'like'
                          ? Icons.favorite
                          : notification.type == 'follow'
                              ? Icons.person_add
                              : notification.type == 'comment'
                                  ? Icons.comment
                                  : notification.type == 'message'
                                      ? Icons.chat_bubble
                                      : notification.type == 'reel_like'
                                          ? Icons.video_library
                                          : Icons.notifications,
                      ),
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(notification.body),
                    onTap: () async {
              if (!notification.isRead) {
                await notificationService.markAsRead(
                  notification.id,
                );
              }

              if (!context.mounted) return;

              if (notification.type == 'follow' &&
                  notification.senderId.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                      userId: notification.senderId,
                    ),
                  ),
                );
              } else if ((notification.type == 'like' ||
                      notification.type == 'comment' ||
                      notification.type == 'reel_like') &&
                  notification.postId != null &&
                  notification.postId!.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommentsScreen(
                      postId: notification.postId!,
                    ),
                  ),
                );
              } else if (notification.type == 'message' &&
                  notification.senderId.isNotEmpty) {
                try {
                  final userDoc = await FirebaseFirestore.instance
                      .collection('users')
                      .doc(notification.senderId)
                      .get();

                  final userData = userDoc.data();
                  final username =
                      userData?['name']?.toString() ?? 'User';

                  if (!context.mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(
                        otherUserId: notification.senderId,
                        otherUsername: username,
                      ),
                    ),
                  );
                } catch (_) {}
              }
            },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
