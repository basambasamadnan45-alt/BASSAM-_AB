import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/comment_model.dart';
import '../services/comment_service.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final CommentService _commentService = CommentService();
  final TextEditingController _controller =
      TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    final text = _controller.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (text.isEmpty || user == null) return;

    try {
      await _commentService.addComment(
        postId: widget.postId,
        userId: user.uid,
        username: user.email ?? 'مستخدم',
        userPhoto: '',
        text: text,
      );

      _controller.clear();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر إضافة التعليق'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التعليقات'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: _commentService
                  .getComments(widget.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'حدث خطأ أثناء تحميل التعليقات',
                    ),
                  );
                }

                final comments = snapshot.data ?? [];

                if (comments.isEmpty) {
                  return const Center(
                    child: Text('لا توجد تعليقات بعد'),
                  );
                }

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          comment.username.isNotEmpty
                              ? comment.username[0]
                              : '?',
                        ),
                      ),
                      title: Text(comment.username),
                      subtitle: Text(comment.text),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                        ),
                        onPressed: () async {
                          final user =
                              FirebaseAuth.instance.currentUser;

                          if (user == null) return;

                          if (comment.likes
                              .contains(user.uid)) {
                            await _commentService
                                .unlikeComment(
                              postId: widget.postId,
                              commentId: comment.id,
                              userId: user.uid,
                            );
                          } else {
                            await _commentService
                                .likeComment(
                              postId: widget.postId,
                              commentId: comment.id,
                              userId: user.uid,
                            );
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        hintText: 'اكتب تعليقًا...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _addComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
