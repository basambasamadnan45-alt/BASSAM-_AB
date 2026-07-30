import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Connect AB',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.search, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.notifications_none, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.chat_bubble_outline, color: Colors.black),
          ),
        ],
      ),

      body: const Center(
        child: Text(
          'Welcome to Connect AB',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'الفيديو',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'إضافة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'الرسائل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
