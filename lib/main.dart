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
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.message,
                    size: 70,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 25),

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

                AppButton(
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

                AppButton(
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
      body: GradientBackground(
        child: FormBox(
          title: 'إنشاء حساب',
          fields: const [
            'رقم الهاتف',
            'البريد الإلكتروني',
            'كلمة المرور',
          ],
          button: 'إنشاء حساب',
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
      body: GradientBackground(
        child: FormBox(
          title: 'تسجيل الدخول',
          fields: const [
            'رقم الهاتف أو البريد الإلكتروني',
            'كلمة المرور',
          ],
          button: 'دخول',
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
      body: GradientBackground(
        child: Center(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: const Text(
              'مرحباً بك في Message AB',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({
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
        ),
      ),
      child: child,
    );
  }
}


class FormBox extends StatelessWidget {
  final String title;
  final List<String> fields;
  final String button;

  const FormBox({
    super.key,
    required this.title,
    required this.fields,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Directionality(
          textDirection: TextDirection.rtl,
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
                      filled: true,
                      fillColor: Colors.white,
                      hintText: field,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              AppButton(
                text: button,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AppButton({
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
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
