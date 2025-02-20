// action_buttons.dart
import 'package:flutter/material.dart';
import 'package:sincot/localcontract.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:sincot/localacceptance.dart';

class ActionButtons extends StatelessWidget {
  final bool isProfileSaved;
  final VoidCallback onSave;
  final String workerPin;

  const ActionButtons({
    super.key,
    required this.isProfileSaved,
    required this.onSave,
    required this.workerPin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        color: Colors.grey.shade700,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!isProfileSaved)
                ElevatedButton(
                  onPressed: onSave,
                  style: _buttonStyle(),
                  child: Text('Save Info',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              if (!isProfileSaved) SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UploadDocuments()),
                  );
                },
                style: _buttonStyle(),
                child: Text('Upload Documents',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Localacceptance()),
                  );
                },
                style: _buttonStyle(),
                child: Text('View Policies and Procedures',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (workerPin.isEmpty) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Localcontract(workerPin: workerPin)),
                  );
                },
                style: _buttonStyle(),
                child: Text('View Contract',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      backgroundColor: Color(0xffe6cf8c),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 0,
    );
  }
}
