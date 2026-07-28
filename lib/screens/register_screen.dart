import 'package:flutter/material.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}


class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController phoneController =
      TextEditingController();

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

                  Icons.person_add,

                  size: 80,

                  color: Colors.white,

                ),


                const SizedBox(height: 20),


                const Text(

                  'إنشاء حساب',

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 32,

                    fontWeight: FontWeight.bold,

                  ),

                ),


                const SizedBox(height: 30),


                TextField(

                  controller: phoneController,

                  keyboardType: TextInputType.phone,

                  decoration: InputDecoration(

                    hintText: 'رقم الهاتف',

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

                  controller: emailController,

                  keyboardType:
                      TextInputType.emailAddress,

                  decoration: InputDecoration(

                    hintText: 'البريد الإلكتروني',

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

                      'إنشاء حساب',

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
