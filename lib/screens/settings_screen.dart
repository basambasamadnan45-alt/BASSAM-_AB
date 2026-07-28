import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'الإعدادات',
        ),
        centerTitle: true,
      ),


      body: ListView(

        padding: const EdgeInsets.all(15),

        children: [

          Card(
            child: ListTile(

              leading: const Icon(
                Icons.person,
              ),

              title: const Text(
                'الحساب',
              ),

              subtitle: const Text(
                'إدارة معلومات الحساب',
              ),

              onTap: () {},

            ),
          ),


          Card(
            child: ListTile(

              leading: const Icon(
                Icons.language,
              ),

              title: const Text(
                'اللغة',
              ),

              subtitle: const Text(
                'العربية',
              ),

              onTap: () {},

            ),
          ),


          Card(
            child: ListTile(

              leading: const Icon(
                Icons.dark_mode,
              ),

              title: const Text(
                'الوضع الليلي',
              ),

              subtitle: const Text(
                'تجهيز للتفعيل لاحقاً',
              ),

              onTap: () {},

            ),
          ),


          Card(
            child: ListTile(

              leading: const Icon(
                Icons.security,
              ),

              title: const Text(
                'الخصوصية والأمان',
              ),

              onTap: () {},

            ),
          ),


          Card(
            child: ListTile(

              leading: const Icon(
                Icons.notifications,
              ),

              title: const Text(
                'الإشعارات',
              ),

              onTap: () {},

            ),
          ),


          const SizedBox(height: 20),


          ElevatedButton.icon(

            onPressed: () {},

            icon: const Icon(
              Icons.logout,
            ),

            label: const Text(
              'تسجيل الخروج',
            ),

          ),


        ],

      ),

    );
  }
}
