// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';

class Authservice {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthResponse?> signInWithEmailPassword(
      String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return response;
    } catch (e) {
      print('Login error: $e');
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  // Sign up with email / pwd
  Future<AuthResponse> signupWithEmailPassword(
      String email, String password) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
  // Get user email

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
