import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pdfview.dart'; // Make sure to import the PDFViewPage

class Localacceptance extends StatefulWidget {
  const Localacceptance({super.key});

  @override
  LocalacceptanceState createState() => LocalacceptanceState();
}

class LocalacceptanceState extends State<Localacceptance> {
  final TextEditingController _portalPinController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? workerData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contract Acceptance'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Only show the form if workerData is null
            if (workerData == null) ...[
              TextFormField(
                controller: _portalPinController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Enter Portal PIN',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _checkPin,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  backgroundColor: Color(0xffe6cf8c),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
            // If workerData is not null, show the worker's data card
            if (workerData != null)
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: workerData!.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _checkPin() async {
    String portalPin = _portalPinController.text;

    // Query the workers table and fetch all fields for the matching record
    final response = await supabase
        .from('workers')
        .select()
        .eq('pin', portalPin)
        .maybeSingle();

    if (!mounted) return;

    setState(() {
      workerData = response;
    });

    if (workerData != null) {
      // If data found, navigate to the PDFViewPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewPage(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid PIN. Have you uploaded your documents?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
