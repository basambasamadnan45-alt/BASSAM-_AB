import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/story_model.dart';
import '../services/story_service.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final ImagePicker _picker = ImagePicker();

  XFile? _selectedFile;
  String _mediaType = 'image';
  bool _loading = false;

  Future<void> _pickMedia() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('التقاط صورة'),
                onTap: () => Navigator.pop(context, 'camera_image'),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('اختيار صورة'),
                onTap: () => Navigator.pop(context, 'image'),
              ),
              ListTile(
                leading: const Icon(Icons.video_library),
                title: const Text('اختيار فيديو'),
                onTap: () => Navigator.pop(context, 'video'),
              ),
            ],
          ),
        );
      },
    );

    if (choice == null) return;

    XFile? file;

    if (choice == 'camera_image') {
      file = await _picker.pickImage(source: ImageSource.camera);
      _mediaType = 'image';
    } else if (choice == 'image') {
      file = await _picker.pickImage(source: ImageSource.gallery);
      _mediaType = 'image';
    } else {
      file = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 60),
      );
      _mediaType = 'video';
    }

    if (file == null) return;

    setState(() {
      _selectedFile = file;
    });
  }

  Future<void> _publishStory() async {
    final file = _selectedFile;
    final user = FirebaseAuth.instance.currentUser;

    if (file == null || user == null) return;

    setState(() => _loading = true);

    try {
      final firestore = FirebaseFirestore.instance;

      final userSnapshot =
          await firestore.collection('users').doc(user.uid).get();

      final userData = userSnapshot.data() ?? {};

      final username =
          userData['username']?.toString() ??
          userData['name']?.toString() ??
          user.email?.split('@').first ??
          'User';

      final ownerPhoto =
          userData['photoUrl']?.toString() ??
          userData['profileImage']?.toString() ??
          '';

      final storyId =
          firestore.collection('stories').doc().id;

      final extension = _mediaType == 'video' ? 'mp4' : 'jpg';

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('stories')
          .child(user.uid)
          .child('$storyId.$extension');

      await storageRef.putFile(File(file.path));

      final mediaUrl = await storageRef.getDownloadURL();

      final now = DateTime.now();

      final story = StoryModel(
        id: storyId,
        ownerId: user.uid,
        ownerUsername: username,
        ownerPhoto: ownerPhoto,
        mediaUrl: mediaUrl,
        mediaType: _mediaType,
        createdAt: now,
        expiresAt: now.add(const Duration(hours: 24)),
        viewers: const [],
        reactions: const [],
      );

      await StoryService().createStory(story);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم نشر القصة بنجاح'),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر نشر القصة: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = _selectedFile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة قصة'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: file == null
                    ? const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_stories,
                            size: 80,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'أضف صورة أو فيديو إلى قصتك',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: _mediaType == 'image'
                            ? Image.file(
                                File(file.path),
                                fit: BoxFit.contain,
                              )
                            : Container(
                                padding: const EdgeInsets.all(30),
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.videocam,
                                      size: 80,
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'تم اختيار الفيديو',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _loading ? null : _pickMedia,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('اختيار صورة أو فيديو'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed:
                    _loading || _selectedFile == null
                        ? null
                        : _publishStory,
                icon: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _loading ? 'جاري النشر...' : 'نشر القصة',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
