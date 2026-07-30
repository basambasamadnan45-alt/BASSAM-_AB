import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _postController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _selectedImage;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<void> _publishPost() async {
    if (_postController.text.trim().isEmpty &&
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("اكتب شيئاً أو اختر صورة"),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("تم نشر المنشور بنجاح"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.blue,
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

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _postController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "بماذا تفكر؟",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  _selectedImage!,
                  height: 230,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text(
                "اختيار صورة",
              ),
            ),

            const SizedBox(height: 15),

            ElevatedButton.icon(
              onPressed: _isLoading ? null : _publishPost,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send),

              label: Text(
                _isLoading ? "جاري النشر..." : "نشر",
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
