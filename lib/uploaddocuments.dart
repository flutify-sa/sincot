// ignore_for_file: avoid_print, unused_local_variable

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadDocuments extends StatefulWidget {
  const UploadDocuments({super.key});

  @override
  UploadDocumentsState createState() => UploadDocumentsState();
}

class UploadDocumentsState extends State<UploadDocuments> {
  bool isIdUploaded = false;
  bool isAddressUploaded = false;
  bool isQualificationsUploaded = false;
  bool isBankConfirmationUploaded = false;
  bool isMedicalUploaded = false;

  Future<void> uploadDocument(String documentType) async {
    // Step 1: Pick a file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );

    if (result == null) {
      return;
    }

    PlatformFile file = result.files.first;
    final fileBytes = file.bytes!;
    final fileName = file.name;

    // Step 2: Create a temporary file
    final tempFile = await _createTempFile(fileBytes, fileName);

    // Step 3: Retrieve the workerpin from the profiles table
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      return;
    }

    final response = await Supabase.instance.client
        .from('profiles')
        .select('workerpin')
        .eq('user_id', userId)
        .single();

    final workerPin = response['workerpin'] as String?;

    if (workerPin == null) {
      return;
    }

    // Step 4: Define the storage path
    final storagePath = 'uploads/$workerPin/$fileName';
    final storage = Supabase.instance.client.storage.from('profiles');

    // Step 5: Upload the file
    final uploadResponse = await storage.upload(storagePath, tempFile);

    // Check for errors in the upload response

    // Step 6: Get the public URL of the uploaded file
    final publicUrl = storage.getPublicUrl(storagePath);
    print('File uploaded to: $publicUrl'); // Use the public URL as needed

    // Optionally, you can update the database with the public URL if needed
    // await Supabase.instance.client
    //     .from('profiles')
    //     .update({fileName.toLowerCase(): publicUrl}).eq('workerpin', workerPin);

    // Update the state to reflect the upload
    setState(() {
      if (documentType == 'ID') isIdUploaded = true;
      if (documentType == 'Address') isAddressUploaded = true;
      if (documentType == 'Qualifications') isQualificationsUploaded = true;
      if (documentType == 'Bank') isBankConfirmationUploaded = true;
      if (documentType == 'Medical') isMedicalUploaded = true;
    });
  }

  Future<File> _createTempFile(Uint8List bytes, String fileName) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Documents'),
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
              secondary: ElevatedButton(
                onPressed: isIdUploaded ? null : () => uploadDocument('ID'),
                child: Text('Upload ID'),
              ),
            ),
            CheckboxListTile(
              title: Text('Proof of Address'),
              value: isAddressUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: ElevatedButton(
                onPressed:
                    isAddressUploaded ? null : () => uploadDocument('Address'),
                child: Text('Upload Address'),
              ),
            ),
            CheckboxListTile(
              title: Text('Qualifications'),
              value: isQualificationsUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: ElevatedButton(
                onPressed: isQualificationsUploaded
                    ? null
                    : () => uploadDocument('Qualifications'),
                child: Text('Upload Qualifications'),
              ),
            ),
            CheckboxListTile(
              title: Text('Bank Confirmation'),
              value: isBankConfirmationUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: ElevatedButton(
                onPressed: isBankConfirmationUploaded
                    ? null
                    : () => uploadDocument('Bank'),
                child: Text('Upload Bank Confirmation'),
              ),
            ),
            CheckboxListTile(
              title: Text('Medical Records'),
              value: isMedicalUploaded,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              secondary: ElevatedButton(
                onPressed:
                    isMedicalUploaded ? null : () => uploadDocument('Medical'),
                child: Text('Upload Medical Records'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
