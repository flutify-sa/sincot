// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sincot/authservice.dart';
import 'package:sincot/loginpage.dart';
import 'package:sincot/mybutton.dart';
import 'package:sincot/mytextfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final SupabaseClient _supabase = Supabase.instance.client;

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void safeSetState(VoidCallback fn) {
    if (!_isDisposed && mounted) {
      setState(fn);
    }
  }

  void showSnackBarMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> register() async {
    if (_isLoading) return;

    safeSetState(() {
      _isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validation checks
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showSnackBarMessage('All fields are required');
      safeSetState(() => _isLoading = false);
      return;
    }

    if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(email)) {
      showSnackBarMessage('Invalid email format');
      safeSetState(() => _isLoading = false);
      return;
    }

    if (password != confirmPassword) {
      showSnackBarMessage('Passwords do not match');
      safeSetState(() => _isLoading = false);
      return;
    }

    if (password.length < 6) {
      showSnackBarMessage('Password must be at least 6 characters long');
      safeSetState(() => _isLoading = false);
      return;
    }

    try {
      // Register the user
      final response =
          await Authservice().signupWithEmailPassword(email, password);
      if (response.user != null) {
        // Insert user data into the 'profiles' table
        final insertResponse = await _supabase.from('profiles').insert([
          {
            'id': response.user!.id,
            'email': email,
            'created_at': DateTime.now().toIso8601String(),
          }
        ]);

        if (insertResponse.error != null) {
          print(
              'Error inserting into profiles table: ${insertResponse.error!.message}');
          showSnackBarMessage('Failed to save profile data');
        } else {
          showSnackBarMessage('Registration Successful');
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
          );
        }
      } else {
        showSnackBarMessage('Registration failed');
      }
    } catch (e) {
      showSnackBarMessage('Error: $e');
    } finally {
      safeSetState(() => _isLoading = false);
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
                  'Sincot Trading\nRegister Screen',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Color(0xffe6cf8c)),
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
                obscuretext: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    safeSetState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirm Portal Pin',
                obscuretext: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    safeSetState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: _isLoading ? null : register,
                text: _isLoading ? 'Loading...' : 'Sign Up',
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already registered?',
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(width: 3),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(onTap: () {}),
                        ),
                      );
                    },
                    child: Text(
                      ' Sign in here',
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
