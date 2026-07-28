import 'package:flutter/material.dart';

void main() {
  runApp(const MessageABApp());
}

class MessageABApp extends StatelessWidget {
  const MessageABApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Message AB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.message,
                    size: 60,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Message AB',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'مرحباً بك في تطبيق Message AB',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 35),

                TextField(
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'رقم الهاتف',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    },
                    child: const Text(
                      'دخول',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message AB'),
        centerTitle: true,
      ),

      body: const Directionality(
        textDirection: TextDirection.rtl,
        child: Center(
          child: Text(
            'أهلاً بك في الصفحة الرئيسية',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
