import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/story_model.dart';
import '../services/story_service.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late int _index;
  VideoPlayerController? _videoController;

  StoryModel get story => widget.stories[_index];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    _videoController?.dispose();
    _videoController = null;

    if (story.mediaType == 'video') {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(story.mediaUrl));

      _videoController = controller;

      try {
        await controller.initialize();
        await controller.setLooping(true);
        await controller.play();

        if (mounted) setState(() {});
      } catch (_) {
        if (mounted) setState(() {});
      }
    }

    await _markViewed();
  }

  Future<void> _markViewed() async {
    final userId = story.ownerId;

    if (!story.viewers.contains(userId)) {
      final viewers = List<String>.from(story.viewers);
      viewers.add(userId);

      try {
        await StoryService().addViewer(story.id, viewers);
      } catch (_) {}
    }
  }

  Future<void> _next() async {
    if (_index < widget.stories.length - 1) {
      setState(() => _index++);
      await _loadMedia();
    } else {
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _previous() async {
    if (_index > 0) {
      setState(() => _index--);
      await _loadMedia();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = story.mediaType == 'video';
    final controller = _videoController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isVideo &&
                controller != null &&
                controller.value.isInitialized)
              Center(
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              )
            else if (!isVideo && story.mediaUrl.isNotEmpty)
              Center(
                child: Image.network(
                  story.mediaUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 60,
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: story.ownerPhoto.isNotEmpty
                        ? NetworkImage(story.ownerPhoto)
                        : null,
                    child: story.ownerPhoto.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      story.ownerUsername,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),

            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _previous,
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _next,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
