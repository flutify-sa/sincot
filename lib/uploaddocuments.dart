// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:sincot/loginpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sincot/uploadbutton.dart';
import 'package:sincot/authservice.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  UploadDocumentsState createState() => UploadDocumentsState();
}

class UploadDocumentsState extends State<UploadDocuments> {
  bool isIdUploaded = false;
  bool isAddressUploaded = false;
  bool isQualificationsUploaded = false;
  bool isEEA1Uploaded = false;
  bool isBankConfirmationUploaded = false;
  bool isMedicalUploaded = false;

  final Authservice _authService = Authservice();

  Future<void> uploadDocument(String documentType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: true,
      );

      if (result == null) {
        print("No file selected.");
        return;
      }

      PlatformFile file = result.files.first;
      if (file.bytes == null) {
        print('No file bytes available for ${file.name}.');
        return;
      }

      final fileBytes = file.bytes!;
      final fileName = file.name;

      final tempFile = await _createTempFile(fileBytes, fileName);

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print("User ID is not available.");
        return;
      }

      final storagePath = 'uploads/$userId/$documentType/$fileName';
      final storage = Supabase.instance.client.storage.from('profiles');
      await storage.upload(storagePath, tempFile);

      setState(() {
        if (documentType == 'ID') isIdUploaded = true;
        if (documentType == 'Address') isAddressUploaded = true;
        if (documentType == 'Qualifications') isQualificationsUploaded = true;
        if (documentType == 'EEA1') isEEA1Uploaded = true;
        if (documentType == 'Bank') isBankConfirmationUploaded = true;
        if (documentType == 'Medical') isMedicalUploaded = true;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<File> _createTempFile(Uint8List bytes, String fileName) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    bool allDocumentsUploaded = isIdUploaded &&
        isAddressUploaded &&
        isQualificationsUploaded &&
        isEEA1Uploaded &&
        isBankConfirmationUploaded;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Documents'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(onTap: () {})),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CheckboxListTile(
              title: Text('Copy of ID'),
              value: isIdUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: UploadButtonButton(
                onTap: isIdUploaded ? null : () => uploadDocument('ID'),
                text: 'Upload',
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: Text('Proof of Address'),
              value: isAddressUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: UploadButtonButton(
                onTap:
                    isAddressUploaded ? null : () => uploadDocument('Address'),
                text: 'Upload',
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: Text('Qualifications'),
              value: isQualificationsUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: UploadButtonButton(
                onTap: isQualificationsUploaded
                    ? null
                    : () => uploadDocument('Qualifications'),
                text: 'Upload',
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: Text('EEA1 Form'),
              value: isEEA1Uploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: UploadButtonButton(
                onTap: isEEA1Uploaded ? null : () => uploadDocument('EEA1'),
                text: 'Upload',
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: Text('Bank Confirmation'),
              value: isBankConfirmationUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: UploadButtonButton(
                onTap: isBankConfirmationUploaded
                    ? null
                    : () => uploadDocument('Bank'),
                text: 'Upload',
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: Text('Medical Certificate'),
              value: isMedicalUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: UploadButtonButton(
                onTap:
                    isMedicalUploaded ? null : () => uploadDocument('Medical'),
                text: 'Upload',
              ),
            ),
            if (allDocumentsUploaded)
              Text(
                'All required documents uploaded. You can upload your medical certificate later.',
                style: TextStyle(color: Colors.green, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
