// ignore_for_file: avoid_print, unused_local_variable, deprecated_member_use

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      withData: true,
    );

    if (result == null) return;

    PlatformFile file = result.files.first;
    final fileBytes = file.bytes!;
    final fileName = file.name;

    final tempFile = await _createTempFile(fileBytes, fileName);
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) return;

    final response = await Supabase.instance.client
        .from('profiles')
        .select('workerpin')
        .eq('user_id', userId)
        .single();

    final workerPin = response['workerpin'] as String?;

    if (workerPin == null) return;

    final storagePath = 'uploads/$workerPin/$fileName';
    final storage = Supabase.instance.client.storage.from('profiles');
    await storage.upload(storagePath, tempFile);

    final publicUrl = storage.getPublicUrl(storagePath);
    print('File uploaded to: $publicUrl');

    setState(() {
      switch (documentType) {
        case 'ID':
          isIdUploaded = true;
          break;
        case 'Address':
          isAddressUploaded = true;
          break;
        case 'Qualifications':
          isQualificationsUploaded = true;
          break;
        case 'Bank':
          isBankConfirmationUploaded = true;
          break;
        case 'Medical':
          isMedicalUploaded = true;
          break;
      }
    });
  }

  Future<File> _createTempFile(Uint8List bytes, String fileName) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  // Custom button style
  ButtonStyle customButtonStyle({bool isEnabled = true}) {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: isEnabled ? Color(0xffe6cf8c) : Colors.grey[400],
      disabledBackgroundColor: Colors.grey[400],
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: isEnabled ? 4 : 0,
      shadowColor: Colors.black.withOpacity(0.2),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Match ProfilePage background
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Upload Documents',
          style: TextStyle(color: Color(0xffe6cf8c)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please upload all required documents below:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            _buildDocumentTile(
              title: 'Copy of ID',
              isUploaded: isIdUploaded,
              onUpload: () => uploadDocument('ID'),
              buttonText: 'Upload ID',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              title: 'Proof of Address',
              isUploaded: isAddressUploaded,
              onUpload: () => uploadDocument('Address'),
              buttonText: 'Upload Address',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              title: 'Qualifications',
              isUploaded: isQualificationsUploaded,
              onUpload: () => uploadDocument('Qualifications'),
              buttonText: 'Upload Qualifications',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              title: 'Bank Confirmation',
              isUploaded: isBankConfirmationUploaded,
              onUpload: () => uploadDocument('Bank'),
              buttonText: 'Upload Bank Confirmation',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              title: 'Medical Records',
              isUploaded: isMedicalUploaded,
              onUpload: () => uploadDocument('Medical'),
              buttonText: 'Upload Medical Records',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTile({
    required String title,
    required bool isUploaded,
    required VoidCallback onUpload,
    required String buttonText,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: isUploaded,
            onChanged: null,
            activeColor: Color(0xffe6cf8c),
            checkColor: Colors.black,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: isUploaded ? null : onUpload,
            style: customButtonStyle(isEnabled: !isUploaded),
            child: Text(
              buttonText,
              style: TextStyle(
                color: isUploaded ? Colors.grey[600] : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
