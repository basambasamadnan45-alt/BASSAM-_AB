import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../services/post_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final PostService _postService = PostService();

  File? _selectedImage;
  File? _selectedVideo;
  String _mediaType = 'text';
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
      _selectedVideo = null;
      _mediaType = 'image';
    });
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 5),
    );

    if (video == null) return;

    setState(() {
      _selectedVideo = File(video.path);
      _selectedImage = null;
      _mediaType = 'video';
    });
  }


  Future<void> _publishPost() async {
    if (_postController.text.trim().isEmpty &&
        _selectedImage == null &&
        _selectedVideo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("اكتب منشورًا أو اختر صورة"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("يجب تسجيل الدخول أولاً");
      }

String imageUrl = '';

    final mediaFile = _selectedVideo ?? _selectedImage;

    if (mediaFile != null) {
      final extension = _mediaType == 'video' ? 'mp4' : 'jpg';

      final fileName =
          '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.$extension';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child(user.uid)
          .child(fileName);

      await storageRef.putFile(mediaFile);
      imageUrl = await storageRef.getDownloadURL();
    }

            await _postService.createPost(
        text: _postController.text.trim(),
        imageUrl: imageUrl,
        mediaType: _mediaType,
        userId: user.uid,
        username: user.email ?? "مستخدم",
      );
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم نشر المنشور بنجاح"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF7C4DFF),
        centerTitle: true,
        title: const Text(
          "إضافة منشور",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _postController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "بماذا تفكر؟",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("اختيار صورة"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
            
Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _pickImage,
            icon: const Icon(Icons.image_outlined),
            label: const Text('صورة'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _pickVideo,
            icon: const Icon(Icons.video_library_outlined),
            label: const Text('فيديو'),
          ),
        ),
      ],
    ),

    const SizedBox(height: 16),
    
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _publishPost,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(
                _isLoading ? "جاري النشر..." : "نشر",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7C4DFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}
