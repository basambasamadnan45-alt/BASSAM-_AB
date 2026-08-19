import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore_service.dart';

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
  final FirestoreService _firestoreService = FirestoreService();

  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isFollowing = false;
  bool isFollowLoading = false;

  @override
  void initState() {
    super.initState();
    loadUser();
    loadFollowStatus();
  }

  Future<void> loadFollowStatus() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final targetUserId = widget.userId;

    if (currentUserId == null ||
        targetUserId == null ||
        currentUserId == targetUserId) {
      return;
    }

    try {
      final snapshot =
          await _firestoreService.getUserProfile(currentUserId);

      if (!mounted) return;

      final data = snapshot.data();
      final following = List<String>.from(
        data?['following'] ?? <String>[],
      );

      setState(() {
        isFollowing = following.contains(targetUserId);
      });
    } catch (_) {
      // تجاهل الخطأ هنا حتى لا تتعطل صفحة الملف الشخصي.
    }
  }

  Future<void> toggleFollow() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final targetUserId = widget.userId;

    if (currentUserId == null ||
        targetUserId == null ||
        currentUserId == targetUserId ||
        isFollowLoading) {
      return;
    }

    setState(() {
      isFollowLoading = true;
    });

    try {
      if (isFollowing) {
        await _firestoreService.unfollowUser(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
        );
      } else {
        await _firestoreService.followUser(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
        );
      }

      if (!mounted) return;

      setState(() {
        isFollowing = !isFollowing;
        isFollowLoading = false;
      });

      await loadUser();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isFollowLoading = false;
      });
    }
  }

  Future<void> loadUser() async {
    final userId = widget.userId ?? FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      if (mounted) {
        setState(() => isLoading = false);
      }
      return;
    }

    try {
      final snapshot = await _firestoreService.getUserProfile(userId);

      if (!mounted) return;

      setState(() {
        userData = snapshot.data();
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر تحميل بيانات الحساب.'),
        ),
      );
    }
  }

  String get displayName {
    final value = userData?['displayName'] ??
        userData?['name'] ??
        'مستخدم';

    return value.toString();
  }

  String get username {
    final value = userData?['username'] ?? '';
    return value.toString();
  }

  String get bio {
    final value = userData?['bio'] ?? '';
    return value.toString();
  }

  String get photoUrl {
    final value = userData?['photoUrl'] ?? '';
    return value.toString();
  }

  int get postsCount {
    return (userData?['postsCount'] ?? 0) as int;
  }

  int get followersCount {
    final followers = userData?['followers'];
    return followers is List ? followers.length : 0;
  }

  int get followingCount {
    final following = userData?['following'];
    return following is List ? following.length : 0;
  }

  Future<void> editProfile() async {
    final nameController = TextEditingController(
      text: displayName == 'مستخدم' ? '' : displayName,
    );

    final usernameController = TextEditingController(
      text: username,
    );

    final bioController = TextEditingController(
      text: bio,
    );

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'تعديل الملف الشخصي',
            textAlign: TextAlign.right,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستخدم',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'النبذة',
                    prefixIcon: Icon(Icons.info_outline),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  {
                    'displayName': nameController.text.trim(),
                    'username': usernameController.text
                        .trim()
                        .toLowerCase()
                        .replaceAll(RegExp(r'\s+'), '_'),
                    'bio': bioController.text.trim(),
                  },
                );
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    usernameController.dispose();
    bioController.dispose();

    if (!mounted) return;
    if (result == null) return;

    final userId = widget.userId ?? FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) return;

    if (result['displayName']!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الاسم لا يمكن أن يكون فارغًا.'),
        ),
      );
      return;
    }

    try {
      await _firestoreService.updateUserProfile(
        uid: userId,
        data: {
          'displayName': result['displayName'],
          'name': result['displayName'],
          'username': result['username'],
          'bio': result['bio'],
        },
      );

      await loadUser();
    loadFollowStatus();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث الملف الشخصي بنجاح.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تعذر تحديث الملف الشخصي.'),
        ),
      );
    }
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            username.isNotEmpty ? '@$username' : 'الملف الشخصي',
          ),
          actions: [
            if (widget.userId != null &&
                widget.userId != FirebaseAuth.instance.currentUser?.uid)
              TextButton(
                onPressed: isFollowLoading ? null : toggleFollow,
                child: isFollowLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isFollowing ? 'إلغاء المتابعة' : 'متابعة'),
              ),
            if (widget.userId == null ||
                widget.userId == FirebaseAuth.instance.currentUser?.uid)
              IconButton(
                onPressed: editProfile,
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'تعديل الملف الشخصي',
              ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: loadUser,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl)
                      : null,
                  child: photoUrl.isEmpty
                      ? const Icon(
                          Icons.person,
                          size: 55,
                          color: Colors.grey,
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (username.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  '@$username',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],

              if (bio.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],

              const SizedBox(height: 25),

              Row(
                children: [
                  _stat('$postsCount', 'منشور'),
                  _stat('$followersCount', 'متابع'),
                  _stat('$followingCount', 'يتابع'),
                ],
              ),

              const SizedBox(height: 25),

              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: editProfile,
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text(
                    'تعديل الملف الشخصي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Divider(),

              const SizedBox(height: 15),

              const Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.grid_on_outlined,
                      size: 32,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'منشوراتك ستظهر هنا',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
