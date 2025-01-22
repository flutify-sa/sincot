// ignore_for_file: avoid_print, sized_box_for_whitespace, unused_import, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sincot/profilepage.dart'; // Ensure this import is correct
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sincot/main.dart';

class LocalContractPage extends StatefulWidget {
  const LocalContractPage({super.key});

  @override
  State<LocalContractPage> createState() => _LocalContractPageState();
}

class _LocalContractPageState extends State<LocalContractPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  Future<void> _generateAndUploadPdf(
      String workerName, String workerSurname) async {
    // Generate the PDF in memory
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Use plain strings instead of Widgets
              pw.Text(
                'INFORMATION FILE',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'The employee agrees that a copy of the Company’s Policies / Procedures / Disciplinary Code, as amended from time to time, was explained to him/her and that a copy will be made available to him/her at the employer’s office / site.\n\n'
                'It is the responsibility of each employee to familiarise themselves with the company’s policies and procedures.\n\n'
                'Signed at # on this 00/00/2024.\n\n'
                'Employee _____________    Witness ______________    Employer ______________',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.Text(
                'CONTRACT OF EMPLOYMENT\n(LIMITED DURATION)',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Entered between:\n'
                'SINCOT TRADING\n(Herein after referred to as "the Employer")\nCHURCH STREET 5b, HENNENMAN, 9445',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.Text(
                'And',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Initials & Surname: #\nI.D. Number: #\n(Herein after referred to as "the Employee")',
                style: pw.TextStyle(fontSize: 16),
              ),
              // Add more sections as needed
              pw.Text(
                'JOB DESCRIPTION',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                '#',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.Text(
                'STATUTORY DEDUCTIONS PER MONTH',
                style:
                    pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'This contract will commence on: # and will be terminated on completion of duties related to tasks for foundation works at AVONDALE or a portion thereof, whichever being the first to materialise. The employee shall be remunerated at R# per hour from the first day clocked in on site/system.\n\n'
                'Pay Cycle will be from the 16th – 15th of each month. Depending on your starting date you might not qualify for a full month salary at the end of the 1st month. Salaries will be released on the last Friday of each month. R&R / Pay Weekend will be unpaid. No pay increases will be considered before 12 Months consecutive work has been completed. '
                'Disciplinary action will be taken against any employee that participates in an unprotected / illegal strike / deliberate go-slows / work stoppage / refusal to work / unauthorised absenteeism. This action can lead to immediate dismissal and the “No Work No Pay” rule will apply. '
                'Please note that no banking details will be changed after the acceptance of this agreement other than what is required by law or ordered by an appropriate court of South Africa.\n\n'
                'Any changes to the above must be communicated to the Employer in writing within 30 (Thirty) days of the change.',
                style: pw.TextStyle(fontSize: 16),
              ),
              // Add other sections similarly
            ],
          );
        },
      ),
    );

    // Save the PDF as a byte array
    final pdfBytes = await pdf.save();

    // Define the filename using the worker's name and surname
    final fileName = '$workerName$workerSurname.pdf';

    // Create a temporary file
    final tempDir = Directory.systemTemp; // Get the system's temp directory
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile
        .writeAsBytes(pdfBytes); // Write the PDF byte array to the file

    // Upload the file to Supabase Storage
    try {
      await supabase.storage
          .from('contracts') // Bucket name
          .upload('profiles/uploads/workerpin/contract/$fileName', tempFile);

      print('PDF uploaded successfully!');
    } catch (e) {
      print('Error uploading PDF: $e');
    } finally {
      // Optionally, delete the temporary file after upload
      await tempFile.delete();
    }
  }

  void _showNameInputDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext, // Use the parent context
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Enter Your Name and Surname'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Surname'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final name = _nameController.text.trim();
                final surname = _surnameController.text.trim();

                if (name.isNotEmpty && surname.isNotEmpty) {
                  // Close the dialog
                  Navigator.of(dialogContext).pop();

                  // Generate and upload the PDF
                  await _generateAndUploadPdf(name, surname);

                  // Navigate to ProfilePage after successful upload
                  Navigator.pushReplacement(
                    parentContext, // Use the parent context
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(), // Replace with your ProfilePage
                    ),
                  );
                } else {
                  // Show an error if fields are empty
                  ScaffoldMessenger.of(parentContext).showSnackBar(
                    SnackBar(
                        content: Text('Please enter both name and surname')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                    _sectionTitle('INFORMATION FILE'),
                    _sectionContent(
                        'The employee agrees that a copy of the Company’s Policies / Procedures / Disciplinary Code, as amended from time to time, was explained to him/her and that a copy will be made available to him/her at the employer’s office / site.\n\n'
                        'It is the responsibility of each employee to familiarise themselves with the company’s policies and procedures.\n\n'
                        'Signed at # on this 00/00/2024.\n\n'
                        'Employee _____________    Witness ______________    Employer ______________'),
                    _sectionTitle('CONTRACT OF EMPLOYMENT\n(LIMITED DURATION)'),
                    _sectionContent('Entered between:'),
                    _sectionContent(
                        'SINCOT TRADING\n(Herein after referred to as "the Employer")\nCHURCH STREET 5b, HENNENMAN, 9445'),
                    _sectionTitle('And'),
                    _sectionContent(
                        'Initials & Surname: #\nI.D. Number: #\n(Herein after referred to as "the Employee")'),
                    _sectionTitle('JOB DESCRIPTION'),
                    _sectionContent('#'),
                    _sectionTitle('STATUTORY DEDUCTIONS PER MONTH'),
                    _sectionContent(
                        'This contract will commence on: # and will be terminated on completion of duties related to tasks for foundation works at AVONDALE or a portion thereof, whichever being the first to materialise. The employee shall be remunerated at R# per hour from the first day clocked in on site/system.\n\n'
                        'Pay Cycle will be from the 16th – 15th of each month. Depending on your starting date you might not qualify for a full month salary at the end of the 1st month. Salaries will be released on the last Friday of each month. R&R / Pay Weekend will be unpaid. No pay increases will be considered before 12 Months consecutive work has been completed. '
                        'Disciplinary action will be taken against any employee that participates in an unprotected / illegal strike / deliberate go-slows / work stoppage / refusal to work / unauthorised absenteeism. This action can lead to immediate dismissal and the “No Work No Pay” rule will apply. '
                        'Please note that no banking details will be changed after the acceptance of this agreement other than what is required by law or ordered by an appropriate court of South Africa.\n\n'
                        'Any changes to the above must be communicated to the Employer in writing within 30 (Thirty) days of the change.'),
                    // Add other sections similarly
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity, // Ensure full width for the row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showNameInputDialog(
                            context); // Pass the parent context
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text(
                        'Accept',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _sectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        content,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
