// ignore_for_file: avoid_print, unused_local_variable, deprecated_member_use, use_build_context_synchronously

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

    if (userId == null) {
      print('No user ID found');
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('workerpin')
          .eq('user_id', userId)
          .single();

      final workerPin = response['workerpin'] as String?;

      if (workerPin == null) {
        print('No worker PIN found for user');
        return;
      }

      final storagePath = 'uploads/$workerPin/$fileName';
      final storage = Supabase.instance.client.storage.from('profiles');

      // Upload the file to Supabase Storage
      await storage.upload(storagePath, tempFile);

      // Get the public URL after successful upload
      final publicUrl = storage.getPublicUrl(storagePath);
      print('File uploaded successfully to: $publicUrl');

      // Update the checkbox state only after successful upload
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
    } catch (e) {
      print('Error uploading document: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload $documentType: $e')),
      );
    } finally {
      // Clean up temporary file
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    }
  }

  Future<File> _createTempFile(Uint8List bytes, String fileName) async {
    final tempDir = await Directory.systemTemp.createTemp();
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsBytes(bytes);
    return tempFile;
  }

  // Custom button style with smaller text
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
        fontSize: 12, // Reduced font size from 16 to 12
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Match ProfilePage background
      appBar: AppBar(
        backgroundColor: (Color(0xffe6cf8c)),
        title: Text(
          'Upload Documents',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please upload all required documents:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 24),
            _buildDocumentTile(
              isUploaded: isIdUploaded,
              onUpload: () => uploadDocument('ID'),
              buttonText: 'Upload ID',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              isUploaded: isAddressUploaded,
              onUpload: () => uploadDocument('Address'),
              buttonText: 'Upload Address',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              isUploaded: isQualificationsUploaded,
              onUpload: () => uploadDocument('Qualifications'),
              buttonText: 'Upload Qualifications',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              isUploaded: isBankConfirmationUploaded,
              onUpload: () => uploadDocument('Bank'),
              buttonText: 'Upload Bank Confirmation',
            ),
            SizedBox(height: 16),
            _buildDocumentTile(
              isUploaded: isMedicalUploaded,
              onUpload: () => uploadDocument('Medical'),
              buttonText: 'Upload Medical Certificate',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTile({
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
            onChanged: null, // Read-only checkbox, updated via upload success
            activeColor: Color(0xffe6cf8c),
            checkColor: Colors.black,
          ),
          SizedBox(width: 12),
          Expanded(
            // Button takes up remaining space
            child: ElevatedButton(
              onPressed: isUploaded ? null : onUpload,
              style: customButtonStyle(isEnabled: !isUploaded),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: isUploaded ? Colors.grey[600] : Colors.black,
                ),
                overflow:
                    TextOverflow.ellipsis, // Truncates button text if too long
              ),
            ),
          ),
        ],
      ),
    );
  }
}
