import 'package:sincot/mybutton.dart';
import 'package:sincot/mytextfield.dart';
import 'package:flutter/material.dart';
import 'package:sincot/profilepage.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

// Login method
  void login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Mitch 09:34'),
      // ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/newlogo.jpg',
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Sincot Trading\nSign In Screen',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xffe6cf8c), // Hex color code
                  ),
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscuretext: false),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscuretext: true),
              const SizedBox(height: 20),
              MyButton(onTap: login, text: 'Sign In'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not registered ? Register',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      'here',
                      style: TextStyle(
                        color: Color(0xffe6cf8c),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
