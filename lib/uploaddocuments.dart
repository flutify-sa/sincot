import 'package:flutter/material.dart';
import 'package:sincot/uploadbutton.dart';

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

  void uploadDocument(String documentType) {
    // Simulate document upload and update checkbox state
    setState(() {
      if (documentType == 'ID') {
        isIdUploaded = true;
      } else if (documentType == 'Address') {
        isAddressUploaded = true;
      } else if (documentType == 'Qualifications') {
        isQualificationsUploaded = true;
      } else if (documentType == 'EEA1') {
        isEEA1Uploaded = true;
      } else if (documentType == 'Bank') {
        isBankConfirmationUploaded = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: Text(
          'Upload Documents',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You need to upload the following:\nCopy of ID.\nProof of Address.\nQualifications\nEEA1\nBank Confirmation.',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                title: Text(
                  'Copy of ID',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isIdUploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isIdUploaded ? null : () => uploadDocument('ID'),
                  text: 'Upload',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  'Proof of Address',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isAddressUploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isAddressUploaded
                      ? null
                      : () => uploadDocument('Address'),
                  text: 'Upload',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  'Qualifications',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isQualificationsUploaded,
                onChanged: null, // Disable editing
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
                title: Text(
                  'EEA1',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isEEA1Uploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isEEA1Uploaded ? null : () => uploadDocument('EEA1'),
                  text: 'Upload',
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                title: Text(
                  'Bank Confirmation',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                value: isBankConfirmationUploaded,
                onChanged: null, // Disable editing
                controlAffinity: ListTileControlAffinity.leading,
                secondary: UploadButtonButton(
                  onTap: isBankConfirmationUploaded
                      ? null
                      : () => uploadDocument(
                            'Bank',
                          ),
                  text: 'Upload',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
