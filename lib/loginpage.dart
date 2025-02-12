// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:sincot/authservice.dart';
import 'package:sincot/mybutton.dart';
import 'package:sincot/mytextfield.dart';
import 'package:flutter/material.dart';
import 'package:sincot/profilepage.dart';
import 'package:sincot/registerpage.dart';

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
  bool _obscureText = true; // To control the visibility of the password

  final Authservice _authService = Authservice();

  // Login method
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response =
          await _authService.signInWithEmailPassword(email, password);

      if (response?.session != null) {
        print('Login successful for user: ${response?.session?.user.email}');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      } else {
        throw Exception('Invalid email or Portal Pin.');
      }
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/newlogo.jpg'),
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
                obscuretext: false,
              ),
              const SizedBox(height: 10),
              // Password TextField with toggle visibility
              MyTextField(
                controller: passwordController,
                hintText: 'Portal Pin',
                obscuretext: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText =
                          !_obscureText; // Toggle password visibility
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              MyButton(onTap: login, text: 'Sign In'),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not registered ? ',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Register here',
                      style: TextStyle(
                          color: Color(0xffe6cf8c),
                          fontWeight: FontWeight.bold),
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
