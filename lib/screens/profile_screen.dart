import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final snapshot =
          await _firestoreService.getUserProfile(user.uid);

      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 55,
              child: Icon(
                Icons.person,
                size: 55,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              userData?['name'] ?? 'مستخدم جديد',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              userData?['email'] ?? '',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              margin: const EdgeInsets.all(15),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('الحساب'),
                subtitle: Text(
                  userData?['uid'] ?? '',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
