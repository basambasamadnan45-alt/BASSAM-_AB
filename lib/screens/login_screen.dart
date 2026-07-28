import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();


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

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(25),

            child: Column(

              children: [

                const Icon(
                  Icons.lock,
                  size: 80,
                  color: Colors.white,
                ),


                const SizedBox(height: 20),


                const Text(

                  'تسجيل الدخول',

                  style: TextStyle(

                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,

                  ),
                ),


                const SizedBox(height: 30),


                TextField(

                  controller: emailController,

                  decoration: InputDecoration(

                    hintText: 'البريد الإلكتروني أو رقم الهاتف',

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(15),

                    ),
                  ),
                ),


                const SizedBox(height: 15),


                TextField(

                  controller: passwordController,

                  obscureText: true,

                  decoration: InputDecoration(

                    hintText: 'كلمة المرور',

                    filled: true,
                    fillColor: Colors.white,

                    border: OutlineInputBorder(

                      borderRadius:
                          BorderRadius.circular(15),

                    ),
                  ),
                ),


                const SizedBox(height: 25),


                SizedBox(

                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton(

                    onPressed: () {

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              const HomeScreen(),

                        ),

                      );

                    },


                    child: const Text(

                      'دخول',

                      style: TextStyle(
                        fontSize: 20,
                      ),

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
