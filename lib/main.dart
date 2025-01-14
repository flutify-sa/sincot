import 'package:sincot/authgate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://eepddugdfgbgrkotwhrg.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVlcGRkdWdkZmdiZ3Jrb3R3aHJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NDA4NDIsImV4cCI6MjA1MjQxNjg0Mn0.9EphzmdSCuj0mmceBP9EWcZ4rP4XYFkzeygsq2-KjYA',
  );
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sincot Trading',
      home: AuthGate(),
    );
  }
}
