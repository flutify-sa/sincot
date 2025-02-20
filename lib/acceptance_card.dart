// acceptance_card.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AcceptanceCard extends StatelessWidget {
  final TextEditingController workerpinController;

  const AcceptanceCard({super.key, required this.workerpinController});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      color: Color(0xffe6cf8c),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: workerpinController,
              decoration: InputDecoration(
                hintText: 'Enter your Worker Pin',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Text(
              '1. I accept the Policies and Procedures.\n2. I accept the Contract.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final currentDateTime = DateTime.now();
                  final formattedDateTime =
                      DateFormat('yyyy-MM-dd HH:mm:ss').format(currentDateTime);
                  final workerPin = workerpinController.text;

                  final response = await supabase
                      .from('profiles')
                      .select('workerpin')
                      .eq('workerpin', workerPin)
                      .maybeSingle();

                  if (response != null) {
                    await supabase
                        .from('profiles')
                        .update({'acceptance': formattedDateTime}).eq(
                            'workerpin', workerPin);

                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirmation'),
                            content: Text(
                                'You have successfully accepted the Policies and Procedures as well as the contract.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                child: Text(
                  'Confirm Acceptance',
                  style: TextStyle(color: Color(0xffe6cf8c), fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
