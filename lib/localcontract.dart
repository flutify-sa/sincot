import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Localcontract extends StatefulWidget {
  const Localcontract({super.key});

  @override
  State<Localcontract> createState() => _LocalcontractState();
}

class _LocalcontractState extends State<Localcontract> {
  String? pdfFilePath;

  @override
  void initState() {
    super.initState();
    loadPdfFromAssets();
  }

  Future<void> loadPdfFromAssets() async {
    try {
      // Load PDF from assets
      ByteData data = await rootBundle.load('assets/local.pdf');
      Uint8List bytes = data.buffer.asUint8List();

      // Save to a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/local.pdf');
      await tempFile.writeAsBytes(bytes);

      setState(() {
        pdfFilePath = tempFile.path;
      });
    } catch (e) {
      debugPrint("Error loading PDF: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contract'),
      ),
      body: Column(
        children: [
          Expanded(
            child: pdfFilePath != null
                ? PDFView(
                    filePath: pdfFilePath,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
