import 'package:flutter/material.dart';

class Localacceptance extends StatefulWidget {
  const Localacceptance({super.key});

  @override
  LocalacceptanceState createState() => LocalacceptanceState();
}

class LocalacceptanceState extends State<Localacceptance> {
  // Controller for text fields to manage input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  String _contractText = ''; // Variable to hold the contract text

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract\nAcceptance'),
        centerTitle: true, // Centers the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name text field
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16), // Space between fields
            // Surname text field
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: 'Surname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32), // Space for the button
            Center(child: Text(_contractText)),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                // Get the entered name and surname
                String name = _nameController.text;
                String surname = _surnameController.text;

                // Set the contract text with the entered name and surname
                setState(() {
                  _contractText = 'I $name $surname accept the contract.';
                });

                // Optionally, you can show it in a dialog as well
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Entered Data'),
                      content: Text('Name: $name\nSurname: $surname'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                backgroundColor: Color(0xffe6cf8c),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0, // Removes shadow
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.black, // Black text color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
