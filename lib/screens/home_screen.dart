import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Connect AB',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          Card(
            margin: const EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            child: const ListTile(
              leading: CircleAvatar(
                radius: 25,
                child: Icon(Icons.person),
              ),

              title: Text(
                'مرحباً بك في Connect AB',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                'ابدأ التواصل مع الآخرين',
              ),
            ),
          ),


          const SizedBox(height: 20),


          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(15),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,

              children: [

                _homeCard(
                  icon: Icons.chat,
                  title: 'المحادثات',
                ),

                _homeCard(
                  icon: Icons.video_library,
                  title: 'الفيديوهات',
                ),

                _homeCard(
                  icon: Icons.play_circle,
                  title: 'ريلز',
                ),

                _homeCard(
                  icon: Icons.people,
                  title: 'المستخدمون',
                ),

              ],
            ),
          ),

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


  Widget _homeCard({
    required IconData icon,
    required String title,
  }) {

    return Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 45,
            color: Colors.blue,
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

        ],
      ),
    );
  }
}
