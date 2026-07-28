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
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.message,
              size: 90,
              color: Colors.white,
            ),

            const SizedBox(height: 20),

            const Text(
              'Message AB',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'تواصل مع العالم بسهولة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 50),

            Button(
              text: 'إنشاء حساب',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Button(
              text: 'لدي حساب',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: FormPage(
          title: 'إنشاء حساب',
          fields: const [
            'رقم الهاتف',
            'البريد الإلكتروني',
            'كلمة المرور',
          ],
          button: 'إنشاء حساب',
          action: () {
          },
        ),
      ),
    );
  }
}


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: FormPage(
          title: 'تسجيل الدخول',
          fields: const [
            'رقم الهاتف أو البريد الإلكتروني',
            'كلمة المرور',
          ],
          button: 'دخول',
          action: () {
          },
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
      body: Background(
        child: Column(
          children: [

            const SizedBox(height: 50),

            const Text(
              'Message AB',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [

                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text('لا توجد محادثات'),
                    subtitle: Text('ابدأ محادثة جديدة'),
                  ),

                ],
              ),
            ),

            const Spacer(),

            Button(
              text: 'رسالة جديدة',
              onTap: () {},
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 35,
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 35,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}


class Background extends StatelessWidget {
  final Widget child;

  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child,
          ),
        ),
      ),
    );
  }
}


class FormPage extends StatelessWidget {
  final String title;
  final List<String> fields;
  final String button;
  final VoidCallback action;

  const FormPage({
    super.key,
    required this.title,
    required this.fields,
    required this.button,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 30),

          ...fields.map(
            (field) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextField(
                obscureText: field == 'كلمة المرور',
                decoration: InputDecoration(
                  hintText: field,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Button(
            text: button,
            onTap: action,
          ),

        ],
      ),
    );
  }
}


class Button extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const Button({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
