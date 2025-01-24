// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sincot/contract_text_widget.dart'; // Ensure this import is correct
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data'; // For Uint8List

class LocalContractPage extends StatefulWidget {
  final String name;
  final String surname;
  final String mobile;
  final String id;
  final String address;
  final String bankDetails;
  final String nextOfKin;
  final String said;
  final String workerpin;
  final String childrenNames;
  final String parentDetails;

  const LocalContractPage({
    super.key,
    required this.name,
    required this.surname,
    required this.mobile,
    required this.id,
    required this.address,
    required this.bankDetails,
    required this.nextOfKin,
    required this.said,
    required this.workerpin,
    required this.childrenNames,
    required this.parentDetails,
  });

  @override
  State<LocalContractPage> createState() => _LocalContractPageState();
}

class _LocalContractPageState extends State<LocalContractPage> {
  // Controllers for the dialog fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController bankDetailsController = TextEditingController();
  final TextEditingController nextOfKinController = TextEditingController();
  final TextEditingController saidController = TextEditingController();
  final TextEditingController workerpinController = TextEditingController();
  final TextEditingController childrenNamesController = TextEditingController();
  final TextEditingController parentDetailsController = TextEditingController();

  @override
  void dispose() {
    // Dispose all controllers to avoid memory leaks
    nameController.dispose();
    surnameController.dispose();
    mobileController.dispose();
    idController.dispose();
    addressController.dispose();
    bankDetailsController.dispose();
    nextOfKinController.dispose();
    saidController.dispose();
    workerpinController.dispose();
    childrenNamesController.dispose();
    parentDetailsController.dispose();
    super.dispose();
  }

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
                  ContractTextWidget(
                    name: widget.name,
                    surname: widget.surname,
                    mobile: widget.mobile,
                    id: widget.id,
                    address: widget.address,
                    bankDetails: widget.bankDetails,
                    nextOfKin: widget.nextOfKin,
                    said: widget.said,
                    workerpin: widget.workerpin,
                    childrenNames: widget.childrenNames,
                    parentDetails: widget.parentDetails,
                  ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> saveTextToSupabaseStorage(
      String textContent, String fileName) async {
    try {
      // Convert the text content to binary data (Uint8List)
      Uint8List fileBytes = Uint8List.fromList(textContent.codeUnits);

      // Upload the file to the 'contracts' bucket
      await Supabase.instance.client.storage
          .from('contracts') // Bucket name
          .uploadBinary(fileName, fileBytes); // File name and binary data

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contract saved successfully!')),
      );
      return true;
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save contract: $e')),
      );
      return false;
    }
  }

  void _logoutUser(BuildContext context) {
    // Implement your logout logic here
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _showAcceptContractDialog(BuildContext context) {
    // Pre-fill the controllers with the current values
    nameController.text = widget.name;
    surnameController.text = widget.surname;
    mobileController.text = widget.mobile;
    idController.text = widget.id;
    addressController.text = widget.address;
    bankDetailsController.text = widget.bankDetails;
    nextOfKinController.text = widget.nextOfKin;
    saidController.text = widget.said;
    workerpinController.text = widget.workerpin;
    childrenNamesController.text = widget.childrenNames;
    parentDetailsController.text = widget.parentDetails;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Your Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: surnameController,
                  decoration: InputDecoration(labelText: 'Surname'),
                ),
                TextField(
                  controller: mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                ),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(labelText: 'ID'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: bankDetailsController,
                  decoration: InputDecoration(labelText: 'Bank Details'),
                ),
                TextField(
                  controller: nextOfKinController,
                  decoration: InputDecoration(labelText: 'Next of Kin'),
                ),
                TextField(
                  controller: saidController,
                  decoration: InputDecoration(labelText: 'SA ID'),
                ),
                TextField(
                  controller: workerpinController,
                  decoration: InputDecoration(labelText: 'Worker Pin'),
                ),
                TextField(
                  controller: childrenNamesController,
                  decoration: InputDecoration(labelText: 'Children Names'),
                ),
                TextField(
                  controller: parentDetailsController,
                  decoration: InputDecoration(labelText: 'Parent Details'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get the entered values
                String name = nameController.text;
                String surname = surnameController.text;
                String mobile = mobileController.text;
                String id = idController.text;
                String address = addressController.text;
                String bankDetails = bankDetailsController.text;
                String nextOfKin = nextOfKinController.text;
                String said = saidController.text;
                String workerpin = workerpinController.text;
                String childrenNames = childrenNamesController.text;
                String parentDetails = parentDetailsController.text;

                Navigator.of(context).pop(); // Close the dialog

                // Generate the contract content
                String fullContractText = '''
Name: $name
Surname: $surname
Mobile: $mobile
ID: $id
Address: $address
Bank Details: $bankDetails
Next of Kin: $nextOfKin
SA ID: $said
Worker PIN: $workerpin
Children Names: $childrenNames
Parent Details: $parentDetails
''';

                // Create the file name using name and surname
                String fileName = '${name}_$surname.txt';

                // Save the text to Supabase Storage
                await saveTextToSupabaseStorage(fullContractText, fileName);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
