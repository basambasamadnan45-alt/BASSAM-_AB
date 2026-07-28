import 'package:flutter/material.dart';

void main() {
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
      body: GradientBackground(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'تواصل مع العالم بسهولة',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 50),

            MainButton(
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

            MainButton(
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
      body: GradientBackground(
        child: AccountForm(
          title: 'إنشاء حساب',
          fields: const [
            'رقم الهاتف',
            'البريد الإلكتروني',
            'كلمة المرور',
          ],
          buttonText: 'إنشاء حساب',
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
        child: AccountForm(
          title: 'تسجيل الدخول',
          fields: const [
            'البريد الإلكتروني أو رقم الهاتف',
            'كلمة المرور',
          ],
          buttonText: 'دخول',
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
        child: Column(
          children: [

            const SizedBox(height: 50),

            const Text(
              'Connect AB',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
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
                    title: Text('مرحباً بك في Connect AB'),
                    subtitle: Text('ابدأ التواصل مع الآخرين'),
                  ),

                ],
              ),
            ),

            const Spacer(),

            MainButton(
              text: 'رسالة جديدة',
              onTap: () {},
            ),

            const SizedBox(height: 20),

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


class AccountForm extends StatelessWidget {

  final String title;
  final List<String> fields;
  final String buttonText;

  const AccountForm({
    super.key,
    required this.title,
    required this.fields,
    required this.buttonText,
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

          MainButton(
            text: buttonText,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
            },
          ),

        ],
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


class MainButton extends StatelessWidget {

  final String text;
  final VoidCallback onTap;

  const MainButton({
    super.key,
    required this.text,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 260,
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
