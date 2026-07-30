import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'create_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'BASSAM AB',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'لا توجد منشورات بعد',
              ),
            );
          }

          final posts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: posts.length,

            itemBuilder: (context, index) {
              final data =
                  posts[index].data()
                      as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    ListTile(
                      leading:
                          const CircleAvatar(
                        child:
                            Icon(Icons.person),
                      ),

                      title: Text(
                        data['username'] ??
                            'مستخدم',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      subtitle:
                          const Text(
                        'منذ قليل',
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.all(12),

                      child: Text(
                        data['text'] ?? '',
                        style:
                            const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,

                      children: [

                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                          ),
                          onPressed: () {},
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.comment,
                          ),
                          onPressed: () {},
                        ),

                        IconButton(
                          icon: const Icon(
                            Icons.share,
                          ),
                          onPressed: () {},
                        ),

                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      floatingActionButton:
          FloatingActionButton(
        backgroundColor: Colors.blue,

        child: const Icon(
          Icons.add,
        ),

        onPressed: () {
          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (context) =>
                  const CreatePostScreen(),
            ),
          );
        },
      ),
    );
  }
}
