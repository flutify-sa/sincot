// Listens for auth state changes
// No need to log in if you are already logged in
// If not authenticated - Login page
// If ok -> Profile page

import 'package:flutter/material.dart';
import 'package:sincot/loginpage.dart';
import 'package:sincot/profilepage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      //build appropriate page
      builder: (context, snapshot) {
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return ProfilePage();
        } else {
          return LoginPage(
            onTap: () {},
          );
        }
      },
    );
  }
}
