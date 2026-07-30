import 'package:flutter/material.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'BASSAM AB',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),

      body: ListView(
        children: [

          SizedBox(
            height: 110,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Container(
                  width: 75,
                  margin: const EdgeInsets.only(right: 10),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'قصة',
                        style: TextStyle(
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),

          Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text(
                'بسام',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: const Text(
                'شارك منشوراً جديداً',
              ),
              trailing: IconButton(
               icon: const Icon(Icons.add_circle),            onPressed: () {
               Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => const CreatePostScreen(),
                 ),
               );
              },
             ),
            ),
          ),

          _postCard(),

          _postCard(),

        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'الرسائل',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الحساب',
          ),
        ],
      ),
    );
  }

  Widget _postCard() {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text(
              'مستخدم BASSAM AB',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'منذ قليل',
            ),
          ),

          Container(
            height: 180,
            color: Colors.blue[100],
            child: const Center(
              child: Icon(
                Icons.image,
                size: 60,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.comment),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
