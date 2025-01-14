import 'package:sincot/mybutton.dart';
import 'package:sincot/mytextfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

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
              MyButton(onTap: () {}, text: 'Sign In'),
            ],
          ),
        ),
      ),
    );
  }
}
