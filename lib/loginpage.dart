// login_page.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:sincot/authservice.dart';
import 'package:sincot/mybutton.dart';
import 'package:sincot/mytextfield.dart';
import 'package:flutter/material.dart';
import 'package:sincot/profilepage.dart'; // Fixed import (was profilepage.dart)
import 'package:sincot/registerpage.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:sincot/profile_service.dart';
import 'package:sincot/dashboard_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _obscureText = true;
  bool _rememberMe = false;

  final Authservice _authService = Authservice();
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedPassword = prefs.getString('password');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (savedEmail != null && savedPassword != null && rememberMe) {
      setState(() {
        emailController.text = savedEmail;
        passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response =
          await _authService.signInWithEmailPassword(email, password);

      if (response?.session != null) {
        print('Login successful for user: ${response?.session?.user.email}');
        await _saveCredentials(email, password);

        // Get user progress from ProfileService
        final progress = await _profileService.getUserProgress();
        final bool isProfileSaved = progress['isProfileSaved']!;
        final bool isDocumentsUploaded = progress['isDocumentsUploaded']!;
        final bool isContractViewed = progress['isContractViewed']!;

        // Navigation logic
        if (!isProfileSaved) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else if (isProfileSaved && !isDocumentsUploaded) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const UploadDocuments()),
          );
        } else if (isProfileSaved && isDocumentsUploaded && !isContractViewed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        } else if (isProfileSaved && isDocumentsUploaded && isContractViewed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        }
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
                    color: Color(0xffe6cf8c),
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
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    checkColor: Colors.black,
                    activeColor: Color(0xffe6cf8c),
                  ),
                  Text(
                    'Remember Me',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MyButton(onTap: login, text: 'Sign In'),
              const SizedBox(height: 10),
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
                        fontWeight: FontWeight.bold,
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
