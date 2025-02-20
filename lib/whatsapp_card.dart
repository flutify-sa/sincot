// whatsapp_card.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappCard extends StatelessWidget {
  final TextEditingController messageController;

  const WhatsappCard({super.key, required this.messageController});

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
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "1. Add 0632616407 to WhatsApp\n2. Enter message\n3. Press WhatsApp button to send message.",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            SizedBox(height: 8),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                hintText: 'Enter message',
                hintStyle: TextStyle(color: Colors.white, fontSize: 12),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => _launchWhatsApp(messageController.text),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  backgroundColor: Color(0xffe6cf8c),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/whatsapp.png', width: 20, height: 20),
                    SizedBox(width: 8),
                    Text(
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
    );
  }
}
