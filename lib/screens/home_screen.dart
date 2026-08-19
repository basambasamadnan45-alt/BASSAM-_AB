import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'comments_screen.dart';
import 'package:share_plus/share_plus.dart';
import '../models/story_model.dart';
import '../services/story_service.dart';
import 'story_viewer_screen.dart';
import 'create_story_screen.dart';

import '../services/post_service.dart';
import 'create_post_screen.dart';
import 'search_screen.dart';

class FeedVideoPlayer extends StatefulWidget {
  final String url;

  const FeedVideoPlayer({
    super.key,
    required this.url,
  });

  @override
  State<FeedVideoPlayer> createState() => _FeedVideoPlayerState();
}

class _FeedVideoPlayerState extends State<FeedVideoPlayer> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.url),
    )
      ..setLooping(true)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return GestureDetector(
      onTap: () {
        if (_controller.value.isPlaying) {
          _controller.pause();
        } else {
          _controller.play();
        }
        setState(() {});
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
          if (!_controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 64,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget _buildStoriesSection() {
    return SizedBox(
      height: 112,
      child: StreamBuilder<List<StoryModel>>(
        stream: StoryService().getStories(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          }

          final stories = snapshot.data ?? [];

          if (stories.isEmpty) {
            return const SizedBox.shrink();
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            itemCount: stories.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CreateStoryScreen(),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                  child: SizedBox(
                    width: 76,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF7C4DFF),
                                Color(0xFF7C4DFF),
                              ],
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 31,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.add,
                              size: 34,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'قصتي',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final story = stories[index - 1];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoryViewerScreen(
                        stories: stories,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  width: 76,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF4081),
                              Color(0xFFFF4081),
                              Color(0xFF7C4DFF),
                            ],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 31,
                          backgroundColor: Colors.white,
                          backgroundImage: story.ownerPhoto.isNotEmpty
                              ? NetworkImage(story.ownerPhoto)
                              : null,
                          child: story.ownerPhoto.isEmpty
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        story.ownerUsername,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  final PostService _postService = PostService();
  final Set<String> _viewedPosts = <String>{};
  final Set<String> _savedPosts = <String>{};

  Future<void> _toggleSavedPost(String postId) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final wasSaved = _savedPosts.contains(postId);

    setState(() {
      if (wasSaved) {
        _savedPosts.remove(postId);
      } else {
        _savedPosts.add(postId);
      }
    });

    try {
      if (wasSaved) {
        await _postService.unsavePost(
          postId: postId,
          userId: userId,
        );
      } else {
        await _postService.savePost(
          postId: postId,
          userId: userId,
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (wasSaved) {
          _savedPosts.add(postId);
        } else {
          _savedPosts.remove(postId);
        }
      });
    }
  }


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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SearchScreen(),
                  ),
                );
              },
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
        body: Column(
          children: [
            _buildStoriesSection(),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                        final ownerPhoto = data['ownerPhoto']?.toString() ?? '';
                        final caption = data['caption']?.toString() ?? '';

                        final mediaUrls =
                            List<String>.from(data['mediaUrls'] ?? []);

                        final mediaType =
                            data['mediaType']?.toString() ?? 'image';

                        final likes = List<dynamic>.from(data['likes'] ?? []);

                        final commentsCount = data['commentsCount'] ?? 0;

                        final viewsCount = data['viewsCount'] ?? 0;

                        final isLiked = currentUserId != null &&
                            likes.contains(currentUserId);

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: ownerPhoto.isNotEmpty
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
                                  child: mediaType == 'video'
                                      ? FeedVideoPlayer(url: mediaUrls.first)
                                      : Image.network(
                                          mediaUrls.first,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) {
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
                                      color: isLiked ? Color(0xFFFF4081) : null,
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => CommentsScreen(
                                            postId: postId,
                                          ),
                                        ),
                                      );
                                    },
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
  onPressed: () async {
    await _toggleSavedPost(postId);
  },
  icon: Icon(
    _savedPosts.contains(postId)
        ? Icons.bookmark
        : Icons.bookmark_border,
  ),
  tooltip: 'Save post',
),
IconButton(
                                    onPressed: () async {
  try {
    final result = await SharePlus.instance.share(
      ShareParams(
        text: 'Check out this post on Connect AB',
      ),
    );

    if (result.status == ShareResultStatus.success) {
      await _postService.incrementShares(postId);
    }
  } catch (_) {}
},
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
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF7C4DFF),
          onPressed: openCreatePost,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
