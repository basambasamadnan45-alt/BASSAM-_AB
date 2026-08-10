import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/post_service.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService = PostService();
  final Set<String> _viewedPosts = <String>{};

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  Future<void> toggleLike(
    String postId,
    List<dynamic> likes,
  ) async {
    final uid = currentUserId;

    if (uid == null) return;

    try {
      if (likes.contains(uid)) {
        await _postService.unlikePost(
          postId: postId,
          userId: uid,
        );
      } else {
        await _postService.likePost(
          postId: postId,
          userId: uid,
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر تحديث الإعجاب.'),
        ),
      );
    }
  }

  Future<void> _recordPostView(String postId) async {
    if (_viewedPosts.contains(postId)) return;

    _viewedPosts.add(postId);

    try {
      await _postService.incrementViews(postId);
    } catch (_) {
      _viewedPosts.remove(postId);
    }
  }

  Future<void> openCreatePost() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreatePostScreen(),
      ),
    );
  }

  String formatDate(dynamic value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return '${date.day}/${date.month}/${date.year}';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AB Connect',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
              tooltip: 'بحث',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
              tooltip: 'الإشعارات',
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _postService.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'تعذر تحميل المنشورات.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => setState(() {}),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final posts = snapshot.data?.docs ?? [];

            if (posts.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 140),
                    Icon(
                      Icons.photo_library_outlined,
                      size: 70,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 18),
                    Center(
                      child: Text(
                        'لا توجد منشورات بعد',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Text(
                        'كن أول من ينشر شيئًا!',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 90,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final doc = posts[index];
                  final data = doc.data();

                  final postId = data['id']?.toString() ?? doc.id;
    _recordPostView(postId);
                  final username =
                      data['ownerUsername']?.toString() ?? 'مستخدم';
                  final ownerPhoto =
                      data['ownerPhoto']?.toString() ?? '';
                  final caption =
                      data['caption']?.toString() ?? '';

                  final mediaUrls =
                      List<String>.from(data['mediaUrls'] ?? []);

                  final likes =
                      List<dynamic>.from(data['likes'] ?? []);

                  final commentsCount =
                      data['commentsCount'] ?? 0;

                  final viewsCount =
                      data['viewsCount'] ?? 0;

                  final isLiked =
                      currentUserId != null &&
                      likes.contains(currentUserId);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                ownerPhoto.isNotEmpty
                                    ? NetworkImage(ownerPhoto)
                                    : null,
                            child: ownerPhoto.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            formatDate(data['createdAt']),
                          ),
                          trailing: const Icon(
                            Icons.more_vert,
                          ),
                        ),

                        if (mediaUrls.isNotEmpty &&
                            mediaUrls.first.isNotEmpty)
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              mediaUrls.first,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 50,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, progress) {
                                if (progress == null) {
                                  return child;
                                }

                                return const Center(
                                  child:
                                      CircularProgressIndicator(),
                                );
                              },
                            ),
                          ),

                        if (caption.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              14,
                              12,
                              14,
                              4,
                            ),
                            child: Text(
                              caption,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),

                        Row(
                          children: [
                            IconButton(
                              onPressed: () => toggleLike(
                                postId,
                                likes,
                              ),
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked
                                    ? Colors.red
                                    : null,
                              ),
                              tooltip: 'إعجاب',
                            ),
                            Text(
                              '${likes.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.mode_comment_outlined,
                              ),
                              tooltip: 'تعليقات',
                            ),
                            Text(
                              '$commentsCount',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.send_outlined,
                              ),
                              tooltip: 'مشاركة',
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.visibility_outlined,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$viewsCount',
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: openCreatePost,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
