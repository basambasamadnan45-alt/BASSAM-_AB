import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                'حدث خطأ في تحميل الفيديوهات',
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
                'لا توجد Reels حاليًا',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final data = videos[index].data();
              final urls = List<String>.from(data['mediaUrls'] ?? []);

              return _ReelItem(
              postId: videos[index].id,
              likes: List<String>.from(data['likes'] ?? []),
                videoUrl: urls.first,
                username:
                    data['ownerUsername']?.toString() ?? 'مستخدم',
                caption: data['caption']?.toString() ?? '',
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
  final List<String> likes;
  final String videoUrl;
  final String username;
  final String caption;

  const _ReelItem({
    required this.postId,
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


  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
    )..initialize().then((_) {
        if (!mounted) return;

        setState(() {});
        _controller
          ..setLooping(true)
          ..play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlay() {
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
    return GestureDetector(
      onTap: togglePlay,
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
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          Positioned(
            left: 16,
            right: 70,
            bottom: 35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@${widget.username}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (widget.caption.isNotEmpty) ...[
                  const SizedBox(height: 8),
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
          if (_controller.value.isInitialized &&
              !_controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 70,
              ),
            ),
        ],
      ),
    );
  }
}
