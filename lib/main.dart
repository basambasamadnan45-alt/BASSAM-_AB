import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Error: $e");
  }

  runApp(const ConnectAB());
}


class ConnectAB extends StatelessWidget {
  const ConnectAB({super.key});


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'Connect AB',

      theme: ThemeData(

        primarySwatch: Colors.blue,

        fontFamily: 'Arial',

      ),


      home: const StartScreen(),

      routes: {

        '/login': (context) =>
            const LoginScreen(),

        '/register': (context) =>
            const RegisterScreen(),

        '/home': (context) =>
            const HomeScreen(),

        '/profile': (context) =>
            const ProfileScreen(),

        '/chat': (context) =>
            const ChatScreen(otherUserId: 'test', otherUsername: 'User'),

        '/settings': (context) =>
            const SettingsScreen(),

      },

    );

  }
}



class StartScreen extends StatelessWidget {

  const StartScreen({super.key});


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Colors.blue,

              Colors.purple,

            ],

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

          ),

        ),


        child: Center(

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,


            children: [


              const Icon(

                Icons.public,

                size: 90,

                color: Colors.white,

              ),


              const SizedBox(height: 20),


              const Text(

                'Connect AB',

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 38,

                  fontWeight:
                      FontWeight.bold,

                ),

              ),


              const SizedBox(height: 10),


              const Text(

                'تواصل مع العالم بسهولة',

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 20,

                ),

              ),


              const SizedBox(height: 40),


              ElevatedButton(

                onPressed: () {

                  Navigator.pushNamed(
                    context,
                    '/register',
                  );

                },

                child: const Text(
                  'إنشاء حساب',
                ),

              ),


              const SizedBox(height: 15),


              ElevatedButton(

                onPressed: () {

                  Navigator.pushNamed(
                    context,
                    '/login',
                  );

                },

                child: const Text(
                  'لدي حساب',
                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}
