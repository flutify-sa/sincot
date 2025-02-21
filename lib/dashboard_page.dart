// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  bool isDocumentUploaded = false;
  late TextEditingController messageController;
  String? name;
  String? surname;
  String? said;
  String? workerpin;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    _loadUploadStatus();
    _fetchProfileData();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> _loadUploadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDocumentUploaded = prefs.getBool('isRequestDocumentUploaded') ?? false;
    });
  }

  Future<void> _fetchProfileData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    print('User ID: $userId'); // Log the user ID
    if (userId == null) {
      print('No authenticated user found.');
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('name, surname, said, workerpin')
          .eq('user_id', userId)
          .single();

      print('Supabase response: $response'); // Log the full response

      setState(() {
        name = response['name'] as String?;
        surname = response['surname'] as String?;
        said = response['said'] as String?;
        workerpin = response['workerpin'] as String?;
      });
    } catch (e) {
      print('Error fetching profile data: $e'); // Log any errors
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile data: $e')),
        );
      }
    }
  }

  Future<void> uploadDocument() async {
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

    try {
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

      final prefs = await SharedPreferences.getInstance();
      setState(() {
        isDocumentUploaded = true;
        prefs.setBool('isRequestDocumentUploaded', true);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload document: $e')),
        );
      }
    } finally {
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

  void _launchWhatsApp(String message) async {
    final phoneNumber = '+27632616407';
    final Uri url = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xffe6cf8c),
        title: const Text(
          'Worker Dashboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      'Name: ${name ?? 'Loading...'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'Surname: ${surname ?? 'Loading...'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'ID: ${said ?? 'Loading...'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      'Worker PIN: ${workerpin ?? 'Loading...'}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  'All information and documents have been received. Thank you.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: isDocumentUploaded,
                    onChanged: null,
                    activeColor: const Color(0xffe6cf8c),
                    checkColor: Colors.black,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: isDocumentUploaded
                        ? const Text(
                            'Document Uploaded',
                            style: TextStyle(color: Colors.grey),
                          )
                        : ElevatedButton(
                            onPressed: uploadDocument,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xffe6cf8c),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                              shadowColor: Colors.black.withValues(),
                            ),
                            child: const Text(
                              'Request',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'If there are any changes, please inform us via WhatsApp.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: const InputDecoration(
                  hintText: 'Enter message',
                  hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () => _launchWhatsApp(messageController.text),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    backgroundColor: const Color(0xffe6cf8c),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/whatsapp.png', width: 20, height: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Send via WhatsApp',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
