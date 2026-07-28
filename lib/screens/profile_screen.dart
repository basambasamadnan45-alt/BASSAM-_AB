import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'الملف الشخصي',
        ),
        centerTitle: true,
      ),


      body: SingleChildScrollView(

        child: Column(

          children: [

            const SizedBox(height: 30),


            const CircleAvatar(

              radius: 55,

              child: Icon(
                Icons.person,
                size: 60,
              ),

            ),


            const SizedBox(height: 20),


            const Text(

              'مستخدم Connect AB',

              style: TextStyle(

                fontSize: 24,

                fontWeight: FontWeight.bold,

              ),

            ),


            const SizedBox(height: 10),


            const Text(

              'البريد الإلكتروني أو رقم الهاتف',

              style: TextStyle(

                color: Colors.grey,

                fontSize: 16,

              ),

            ),


            const SizedBox(height: 30),


            Card(

              margin: const EdgeInsets.all(15),

              child: Column(

                children: [

                  ListTile(

                    leading: const Icon(Icons.edit),

                    title: const Text(
                      'تعديل الملف الشخصي',
                    ),

                    onTap: () {},

                  ),


                  const Divider(),


                  ListTile(

                    leading: const Icon(Icons.lock),

                    title: const Text(
                      'الخصوصية والأمان',
                    ),

                    onTap: () {},

                  ),


                  const Divider(),


                  ListTile(

                    leading: const Icon(Icons.settings),

                    title: const Text(
                      'الإعدادات',
                    ),

                    onTap: () {},

                  ),


                ],

              ),

            ),

          ],

        ),

      ),

    );
  }
}
