// action_buttons.dart
import 'package:flutter/material.dart';
import 'package:sincot/localcontract.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:sincot/localacceptance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionButtons extends StatefulWidget {
  // Changed to StatefulWidget
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
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  bool _isContractViewed = false;

  @override
  void initState() {
    super.initState();
    _loadContractViewedStatus();
  }

  Future<void> _loadContractViewedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isContractViewed = prefs.getBool('isContractViewed') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        color: Colors.grey.shade700,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!widget.isProfileSaved)
                ElevatedButton(
                  onPressed: widget.onSave,
                  style: _buttonStyle(),
                  child: const Text('Save Info',
                      style: TextStyle(color: Colors.black, fontSize: 14)),
                ),
              if (!widget.isProfileSaved) const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UploadDocuments()),
                  );
                },
                style: _buttonStyle(),
                child: const Text('Upload Documents',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Localacceptance()),
                  );
                },
                style: _buttonStyle(),
                child: const Text('View Policies and Procedures',
                    style: TextStyle(color: Colors.black, fontSize: 14)),
              ),
              const SizedBox(height: 10),
              if (!_isContractViewed &&
                  widget.workerPin.isNotEmpty) // Only show if not viewed
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Localcontract(workerPin: widget.workerPin),
                      ),
                    );
                  },
                  style: _buttonStyle(),
                  child: const Text('View Contract',
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      backgroundColor: const Color(0xffe6cf8c),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 0,
    );
  }
}
