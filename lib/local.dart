import 'package:flutter/material.dart';
import 'package:sincot/contract_text_widget.dart'; // Ensure this import is correct
import 'package:sincot/profilepage.dart'; // Ensure this import is correct
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // For Uint8List

class LocalContractPage extends StatefulWidget {
  const LocalContractPage({super.key});

  @override
  State<LocalContractPage> createState() => _LocalContractPageState();
}

class _LocalContractPageState extends State<LocalContractPage> {
  bool isProfileButtonActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract of Employment - Local Contract'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Use ContractTextWidget to display the full contract text
                  ContractTextWidget(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Log out the user
                    _logoutUser(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Show confirmation dialog to accept the contract
                    _showAcceptContractDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Accept',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Spacer(), // This will push the next button to the right
                ElevatedButton(
                  onPressed: isProfileButtonActive
                      ? () {
                          // Navigate to ProfilePage only if the button is active
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          );
                        }
                      : null, // Set to null to disable the button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isProfileButtonActive
                        ? Colors.blue
                        : Colors.grey, // Change color when disabled
                  ),
                  child: Text(
                    'Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> saveTextToSupabaseStorage(
      String textContent, String fileName) async {
    // Convert the text content to binary data (Uint8List)
    Uint8List fileBytes = Uint8List.fromList(textContent.codeUnits);

    // Upload the file to the 'contracts' bucket
    await Supabase.instance.client.storage
        .from('contracts') // Bucket name
        .uploadBinary(fileName, fileBytes); // File name and binary data

    // Assume the upload was successful
    return true;
  }

  void _logoutUser(BuildContext context) {
    // Implement your logout logic here
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _showAcceptContractDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Accept Contract'),
          content: Text('Are you sure you want to accept the contract?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog

                // Get the full contract text from ContractTextWidget
                final contractTextWidget = ContractTextWidget();
                String fullContractText = contractTextWidget
                    .getContractContent(); // Use getContractContent()

                // Create a unique file name using a timestamp
                String fileName =
                    'contract_${DateTime.now().millisecondsSinceEpoch}.txt';

                // Save the text to Supabase Storage
                await saveTextToSupabaseStorage(
                  fullContractText,
                  fileName, // Pass the file name
                );

                // Enable the Profile button
                setState(() {
                  isProfileButtonActive = true;
                });
              },
              child: Text('Accept'),
            ),
          ],
        );
      },
    );
  }
}
