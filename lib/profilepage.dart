// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sincot/authservice.dart';
import 'package:sincot/loginpage.dart'; // Make sure to import your auth service for signing out
import 'package:sincot/mybutton.dart';
import 'package:sincot/profiletextfield.dart'; // Assuming you placed the custom text field in this directory

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Authservice _authService =
      Authservice(); // Assuming Authservice handles sign-out

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Logout method
  Future<void> logout() async {
    try {
      await _authService
          .signOut(); // Assuming signOut is implemented in your Authservice
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out successfully')),
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(onTap: () {}), // Navigate back to the login page
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Logout icon
            onPressed: logout, // Trigger logout method when pressed
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileMyTextField(
              controller: _nameController,
              hintText: 'Name',
              obscuretext: false,
            ),
            SizedBox(height: 10),
            ProfileMyTextField(
              controller: _surnameController,
              hintText: 'Surname',
              obscuretext: false,
            ),
            SizedBox(height: 10),
            ProfileMyTextField(
              controller: _usernameController,
              hintText: 'Username',
              obscuretext: false,
            ),
            SizedBox(height: 10),
            ProfileMyTextField(
              controller: _emailController,
              hintText: 'Email',
              obscuretext: false,
            ),
            SizedBox(height: 20),
            MyButton(onTap: () {}, text: 'Save'),
          ],
        ),
      ),
    );
  }
}
