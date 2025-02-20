// localcontract.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sincot/dashboard_page.dart'; // Navigate to DashboardPage after viewing

class Localcontract extends StatelessWidget {
  final String workerPin;

  const Localcontract({super.key, required this.workerPin});

  Future<void> _markContractViewed(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isContractViewed', true);
    // Navigate to DashboardPage (or back to ProfilePage)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: const Color(0xffe6cf8c),
        title: const Text('Contract', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contract for Worker PIN: $workerPin',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'This is a placeholder for the contract content.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _markContractViewed(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffe6cf8c),
              ),
              child: const Text('Acknowledge Contract',
                  style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
