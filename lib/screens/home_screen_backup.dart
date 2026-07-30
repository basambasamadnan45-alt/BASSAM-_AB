import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Connect AB",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
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

      body: Column(
        children: [

          Container(
            height: 105,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [

                const SizedBox(width: 10),

                _storyItem(
                  "قصتي",
                  Icons.add,
                  true,
                ),

                _storyItem(
                  "محمد",
                  Icons.person,
                  false,
                ),

                _storyItem(
                  "أحمد",
                  Icons.person,
                  false,
                ),

                _storyItem(
                  "سارة",
                  Icons.person,
                  false,
                ),

                _storyItem(
                  "علي",
                  Icons.person,
                  false,
                ),

                _storyItem(
                  "نور",
                  Icons.person,
                  false,
                ),

                _storyItem(
                  "زين",
                  Icons.person,
                  false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                                _postCard(
                  name: "بسام",
                  time: "منذ 5 دقائق",
                  text:
                      "مرحبًا بكم في تطبيق Connect AB 🚀",
                ),

                const SizedBox(height: 15),

                _postCard(
                  name: "محمد",
                  time: "منذ ساعة",
                  text:
                      "هذا أول منشور تجريبي داخل التطبيق.",
                ),

                const SizedBox(height: 15),

                _postCard(
                  name: "سارة",
                  time: "منذ ساعتين",
                  text:
                      "نعمل على تطوير منصة عربية حديثة للتواصل.",
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: "الفيديو",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: "إضافة",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "الرسائل",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "حسابي",
          ),
        ],
      ),
    );
  }
  Widget _storyItem(String name, IconData icon, bool isMine) {
  return Container(
    width: 75,
    margin: const EdgeInsets.symmetric(horizontal: 6),
    child: Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            icon,
            color: Colors.blue,
            size: 30,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
  );
}

Widget _postCard({
  required String name,
  required String time,
  required String text,
}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 15),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.image,
                size: 70,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.favorite_border),
              Icon(Icons.comment_outlined),
              Icon(Icons.share_outlined),
            ],
          ),
        ],
      ),
    ),
  );
}
