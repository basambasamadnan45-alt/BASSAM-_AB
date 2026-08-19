import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chat_screen.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please sign in first'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('conversations')
            .where(
              'participants',
              arrayContains: currentUser.uid,
            )
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load messages',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final conversations = snapshot.data?.docs ?? [];

          if (conversations.isEmpty) {
            return const Center(
              child: Text(
                'No conversations yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: conversations.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final data = conversation.data();

              final participants =
                  List<String>.from(data['participants'] ?? <String>[]);

              final otherUserId = participants.firstWhere(
                (id) => id != currentUser.uid,
                orElse: () => '',
              );

              if (otherUserId.isEmpty) {
                return const SizedBox.shrink();
              }

              final lastMessage =
                  data['lastMessage']?.toString() ?? '';

              return FutureBuilder<
                  DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                      title: Text('Loading...'),
                    );
                  }

                  final userData = userSnapshot.data?.data() ?? {};

                  final username =
                      userData['displayName']?.toString().isNotEmpty == true
                          ? userData['displayName'].toString()
                          : userData['name']?.toString().isNotEmpty == true
                              ? userData['name'].toString()
                              : userData['username']?.toString().isNotEmpty ==
                                      true
                                  ? userData['username'].toString()
                                  : 'User';

                  final photoUrl =
                      userData['photoUrl']?.toString() ?? '';

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 27,
                      backgroundImage: photoUrl.isNotEmpty
                          ? NetworkImage(photoUrl)
                          : null,
                      child: photoUrl.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      lastMessage.isEmpty
                          ? 'Start a conversation'
                          : lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            otherUserId: otherUserId,
                            otherUsername: username,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
