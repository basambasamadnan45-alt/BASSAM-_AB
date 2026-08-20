import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;

  const ProfileScreen({
    super.key,
    this.userId,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userData;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _posts = [];

  bool _isLoading = true;

  String get _userId => widget.userId ?? _auth.currentUser?.uid ?? '';

  String get displayName => (_userData?['displayName'] ??
          _userData?['name'] ??
          _auth.currentUser?.displayName ??
          'المستخدم')
      .toString();

  String get username => (_userData?['username'] ?? '').toString();

  String get bio => (_userData?['bio'] ?? '').toString();

  String get photoUrl => (_userData?['photoUrl'] ??
          _userData?['photoURL'] ??
          _auth.currentUser?.photoURL ??
          '')
      .toString();

  int _listCount(String key) {
    final value = _userData?[key];
    return value is List ? value.length : 0;
  }

  int get followersCount => _listCount('followers');

  int get followingCount => _listCount('following');

  int get postsCount {
    final value = _userData?['postsCount'];
    return value is num ? value.toInt() : _posts.length;
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_userId.isEmpty) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    try {
      final userSnapshot =
          await _firestore.collection('users').doc(_userId).get();

      final postsSnapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: _userId)
          .get();

      if (!mounted) return;

      setState(() {
        _userData = userSnapshot.data();
        _posts = postsSnapshot.docs;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تعذر تحميل الملف الشخصي: $e'),
        ),
      );
    }
  }

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: displayName);

    final usernameController = TextEditingController(text: username);

    final bioController = TextEditingController(text: bio);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعديل الملف الشخصي'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'الاسم',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'اسم المستخدم',
                  prefixText: '@',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'النبذة',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () async {
              final usernameValue = usernameController.text
                  .trim()
                  .replaceAll(RegExp(r'\s+'), '_');

              await _firestore.collection('users').doc(_userId).set(
                {
                  'displayName': nameController.text.trim(),
                  'username': usernameValue,
                  'bio': bioController.text.trim(),
                },
                SetOptions(merge: true),
              );

              if (!context.mounted) return;
              Navigator.pop(context, true);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();

    if (result == true) {
      await _loadProfile();
    }
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    if (photoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 46,
        backgroundImage: NetworkImage(photoUrl),
      );
    }

    return const CircleAvatar(
      radius: 46,
      child: Icon(
        Icons.person,
        size: 50,
      ),
    );
  }

  Widget _buildPostsGrid() {
    if (_posts.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.grid_on_outlined,
                size: 48,
              ),
              SizedBox(height: 12),
              Text('لا توجد منشورات بعد'),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final data = _posts[index].data();

        final mediaUrls = List<String>.from(data['mediaUrls'] ?? []);

        if (mediaUrls.isEmpty) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.article_outlined),
          );
        }

        return Image.network(
          mediaUrls.first,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.broken_image_outlined,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_userId.isEmpty) {
      return const Center(
        child: Text('يجب تسجيل الدخول أولًا'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProfile,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                16,
              ),
              child: Column(
                children: [
                  _buildAvatar(),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (username.isNotEmpty)
                    Text(
                      '@$username',
                      style: TextStyle(
                color: const Color(0xFF7C4DFF),
                fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (bio.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      bio,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _stat(
                        '$postsCount',
                        'منشور',
                      ),
                      _stat(
                        '$followersCount',
                        'متابع',
                      ),
                      _stat(
                        '$followingCount',
                        'يتابع',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton.icon(
                      onPressed: _editProfile,
style: OutlinedButton.styleFrom(
  foregroundColor: const Color(0xFF7C4DFF),
  side: const BorderSide(color: Color(0xFF7C4DFF)),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  ),
),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text(
                        'تعديل الملف الشخصي',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: _buildPostsGrid(),
          ),
        ],
      ),
    );
  }
}
