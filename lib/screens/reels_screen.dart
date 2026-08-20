import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';
import '../services/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../services/post_service.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Reels'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Unable to load Reels',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final videos = snapshot.data!.docs.where((doc) {
            final data = doc.data();

            final mediaType = data['mediaType']?.toString() ?? '';
            final urls = List<String>.from(data['mediaUrls'] ?? []);

            return mediaType == 'video' && urls.isNotEmpty;
          }).toList();

          if (videos.isEmpty) {
            return const Center(
              child: Text(
                'No Reels yet',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            );
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final doc = videos[index];
              final data = doc.data();

              final urls = List<String>.from(data['mediaUrls'] ?? []);
              final likes = List<String>.from(data['likes'] ?? []);

              return _ReelItem(
                postId: doc.id,
          ownerId: data['ownerId']?.toString() ?? '',
                videoUrl: urls.first,
          username: data['ownerUsername']?.toString() ?? data['username']?.toString() ?? '',
                caption: data['caption']?.toString() ?? '',
                likes: likes,
              );
            },
          );
        },
      ),
    );
  }
}

class _ReelItem extends StatefulWidget {
  final String postId;
  final String ownerId;
  final List<String> likes;
  final String videoUrl;
  final String username;
  final String caption;

  const _ReelItem({
    required this.postId,
    required this.ownerId,
    required this.likes,
    required this.videoUrl,
    required this.username,
    required this.caption,
  });

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem> {
  late final VideoPlayerController _controller;

  bool _isLiked = false;
  bool _isLikeLoading = false;

  final PostService _postService = PostService();

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    _isLiked = user != null && widget.likes.contains(user.uid);

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )
      ..setLooping(true)
      ..initialize().then((_) {
        if (!mounted) return;

        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleLike() async {
    if (_isLikeLoading) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to like this Reel'),
        ),
      );

      return;
    }

    setState(() {
      _isLikeLoading = true;
      _isLiked = !_isLiked;
    });

    try {
      if (_isLiked) {
        await _postService.likePost(
          postId: widget.postId,
          userId: user.uid,
        );
      await _notifyReelOwner(
        type: 'reel_like',
        title: 'New Reel like',
        body: 'Someone liked your Reel.',
      );
      } else {
        await _postService.unlikePost(
          postId: widget.postId,
          userId: user.uid,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLiked = !_isLiked;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Like failed: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLikeLoading = false;
        });
      }
    }
  }

  Future<void> _shareReel() async {
    try {
      final result = await SharePlus.instance.share(
        ShareParams(
          text: widget.caption.isNotEmpty
              ? '${widget.username}: ${widget.caption}'
              : 'Check out this Reel on Connect AB',
        ),
      );

      if (result.status == ShareResultStatus.success) {
        await _postService.incrementShares(widget.postId);
        await _notifyReelOwner(
          type: 'share',
          title: 'Reel shared',
          body: 'Someone shared your Reel.',
        );
      }
    } catch (_) {}
  }

  
  Future<void> _notifyReelOwner({
    required String type,
    required String title,
    required String body,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || widget.postId.isEmpty) return;

    try {
      final postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .get();

      final postData = postSnapshot.data() ?? <String, dynamic>{};
      final ownerId = postData['ownerId']?.toString() ?? '';

      if (ownerId.isEmpty || ownerId == currentUser.uid) return;

      final notification = NotificationModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        receiverId: ownerId,
        senderId: currentUser.uid,
        type: type,
        title: title,
        body: body,
        isRead: false,
        createdAt: DateTime.now(),
      postId: widget.postId,
      );

      await NotificationService().createNotification(notification);
    } catch (_) {}
  }

void _togglePlay() {
    if (!_controller.value.isInitialized) return;

    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final likeCount =
        widget.likes.length + (_isLiked && !widget.likes.contains(
          FirebaseAuth.instance.currentUser?.uid,
        ) ? 1 : 0);

    return GestureDetector(
      onTap: _togglePlay,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (_controller.value.isInitialized &&
              !_controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 70,
              ),
            ),

          Positioned(
            right: 12,
            bottom: 110,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggleLike,
                  child: AnimatedScale(
                    scale: _isLiked ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      _isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _isLiked ? Colors.red : Colors.white,
                      size: 38,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$likeCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: _shareReel,
                  child: const Icon(
                    Icons.send_outlined,
                    color: Colors.white,
                    size: 34,
                  ),
                ),
                const SizedBox(height: 6),
    const Text(
            
                  'Share',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 70,
            bottom: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (widget.caption.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    widget.caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
