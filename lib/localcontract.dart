// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Localcontract extends StatefulWidget {
  final String workerPin;

  const Localcontract({required this.workerPin, super.key});

  @override
  State<Localcontract> createState() => _LocalcontractState();
}

class _LocalcontractState extends State<Localcontract> {
  String? textContent;
  final String bucketName = 'profiles';

  @override
  void initState() {
    super.initState();
    print(
        'Initializing fetch for worker pin: ${widget.workerPin}'); // Debug message
    if (widget.workerPin.isNotEmpty) {
      fetchContractFile(widget.workerPin);
    } else {
      print('Worker pin is empty, cannot fetch file'); // Debug message
      setState(() {
        textContent = 'Worker pin is empty. Cannot fetch contract.';
      });
    }
  }

  Future<void> fetchContractFile(String workerPin) async {
    final storage = Supabase.instance.client.storage.from(bucketName);
    final storagePath = 'uploads/$workerPin/';

    try {
      print('Fetching files from path: $storagePath'); // Debug message
      // List all files in the worker's directory
      final files = await storage.list(path: storagePath);
      print('Found ${files.length} files in the directory.'); // Debug message

      // Find the first .txt file in the directory
      final matchingFile = files.firstWhere(
        (file) => file.name.endsWith('.txt'),
        orElse: () => throw Exception('No text file found for the worker pin'),
      );

      print('Found text file: ${matchingFile.name}'); // Debug message

      // Download the file content
      final fileData =
          await storage.download('$storagePath${matchingFile.name}');
      print('Downloaded ${matchingFile.name} successfully.'); // Debug message

      // Save the file locally
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/${matchingFile.name}');
      await file.writeAsBytes(fileData);

      print('File saved locally at: ${file.path}'); // Debug message

      // Read and display the text file content
      setState(() {
        textContent = file.readAsStringSync();
      });
    } catch (e) {
      print('Error fetching file: $e'); // Debug message for error
      setState(() {
        textContent = 'Failed to fetch contract file.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add margin around the content
        child: SingleChildScrollView(
          // Enable scrolling
          child: textContent != null
              ? Center(child: Text(textContent!))
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
