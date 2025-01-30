// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PDFViewPage extends StatefulWidget {
  const PDFViewPage({super.key});

  @override
  PDFViewPageState createState() => PDFViewPageState();
}

class PDFViewPageState extends State<PDFViewPage> {
  String? _pdfPath;
  late String name;
  late String surname;
  late String pin;

  @override
  void initState() {
    super.initState();
    _loadPDF();
    _getUserProfile();
  }

  // Load the PDF from assets and save it to a temporary directory
  Future<void> _loadPDF() async {
    final ByteData data = await rootBundle.load('assets/terms.pdf');
    final Uint8List bytes = data.buffer.asUint8List();

    // Get the temporary directory of the device
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/terms.pdf');

    // Write the file to the temporary directory
    await file.writeAsBytes(bytes);

    // Set the file path to display the PDF
    setState(() {
      _pdfPath = file.path;
    });
  }

  // Fetch the current user's profile data
  Future<void> _getUserProfile() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user != null) {
      final userData = await supabase
          .from(
              'workers') // Assuming the worker's data is in the 'workers' table
          .select('name, surname, pin') // Select required fields
          .maybeSingle();

      if (userData != null) {
        setState(() {
          name = userData['name'] ?? '';
          surname = userData['surname'] ?? '';
          // Convert pin to String if it's an int
          pin = userData['pin']?.toString() ?? '';
        });
      }
    }
  }

  // Function to handle user logout

  // Function to insert terms data into the table

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: Column(
        children: [
          // Ensure that the PDF view takes up space
          if (_pdfPath != null)
            Expanded(
              child: PDFView(
                filePath: _pdfPath,
              ),
            ),
          if (_pdfPath == null)
            Center(
                child:
                    CircularProgressIndicator()), // Show loading indicator while PDF is loading

          // Add space between PDF and buttons
          SizedBox(height: 20),

          // Accept/Reject buttons row
        ],
      ),
    );
  }
}
