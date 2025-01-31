// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field
import 'package:flutter/material.dart';
import 'package:sincot/localcontract.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sincot/localacceptance.dart'; // Adjust the import according to your file structure

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bankDetailsController = TextEditingController();
  final TextEditingController _nextOfKinController = TextEditingController();
  final TextEditingController _saidController = TextEditingController();
  final TextEditingController _workerpinController = TextEditingController();
  final TextEditingController _childrenNamesController =
      TextEditingController();
  final TextEditingController _parentDetailsController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _saveProfileToSupabase() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;

      if (user == null) {
        _showErrorSnackBar('No user is logged in.');
        return; // Exit the function if no user is logged in
      }

      // If the user is logged in, print the user ID
      print('Logged in user ID: ${user.id}');

      final String userId = user.id; // Use the logged-in user's ID
      final String name = _nameController.text.trim();
      final String surname = _surnameController.text.trim();
      final String mobile = _mobileController.text.trim();
      final String address = _addressController.text.trim();
      final String bankDetails = _bankDetailsController.text.trim();
      final String nextOfKin = _nextOfKinController.text.trim();
      final String said = _saidController.text.trim();
      final String workerpin = _workerpinController.text.trim();
      final String childrenNames = _childrenNamesController.text.trim();
      final String parentDetails = _parentDetailsController.text.trim();

      final updates = {
        'user_id': userId,
        'name': name,
        'surname': surname,
        'mobile_number': mobile,
        'address': address,
        'bank_details': bankDetails,
        'next_of_kin': nextOfKin,
        'said': said,
        'workerpin': workerpin,
        'children_names': childrenNames,
        'parent_details': parentDetails,
      };

      print('Data being sent to Supabase: $updates');

      final response = await supabase.from('profiles').upsert(updates);

      // Check if the response is null
      if (response == null) {
        _showErrorSnackBar('No response from Supabase.');
        return;
      }

      if (response.error != null) {
        print('Error: ${response.error!.message}');
        _showErrorSnackBar('Error: ${response.error!.message}');
      } else {
        print('Success: ${response.data}');
        _showSuccessSnackBar('Profile updated successfully!');
      }
    } on PostgrestException catch (e) {
      print('Postgrest Error: ${e.message}');
      _showErrorSnackBar('Supabase error: ${e.message}');
    } catch (e, stackTrace) {
      print('Unexpected Error: $e');
      print('Stack Trace: $stackTrace');
      _showErrorSnackBar('An unexpected error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.red))),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: TextStyle(color: Colors.green))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Fill in ALL the fields below.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Enter your Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your Surname',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your surname';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Enter your Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your mobile number';
                    }
                    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText:
                        'Please enter your Address (Street name and number,\nSuburb, Town and Postal code )',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bankDetailsController,
                  decoration: InputDecoration(
                    labelText:
                        'Bank Details(Bank name, Account Number, Type of account (Savings, etc).\nPut each on a separate line)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  maxLines: 4,
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your bank details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nextOfKinController,
                  decoration: InputDecoration(
                    labelText: 'Next of Kin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter next of kin details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _saidController,
                  decoration: InputDecoration(
                    labelText: 'ID Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your ID number';
                    }
                    if (!RegExp(r'^[0-9]{13}$').hasMatch(value)) {
                      return 'Please enter a valid 13-digit ID number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _workerpinController,
                  decoration: InputDecoration(
                    labelText: 'Worker PIN',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your worker PIN';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _childrenNamesController,
                  decoration: InputDecoration(
                    labelText:
                        'Children Names. Please enter their name and surnames. 1 per line',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  maxLines: 7,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter children names (if applicable)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _parentDetailsController,
                  decoration: InputDecoration(
                    labelText:
                        'Parent Details. Please enter their name and surnames. 1 per line',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter parent details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                _isLoading
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          Card(
                            color: Colors.grey[200],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Left align everything
                                children: [
                                  ElevatedButton(
                                    onPressed: _saveProfileToSupabase,
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      backgroundColor: Color(0xffe6cf8c),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Save Info',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadDocuments()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      backgroundColor: Color(0xffe6cf8c),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'Upload Documents',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Localacceptance()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      backgroundColor: Color(0xffe6cf8c),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'View Policies and Procedures',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Localcontract()),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      backgroundColor: Color(0xffe6cf8c),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      'View Contract',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _surnameController.dispose();
    _addressController.dispose();
    _bankDetailsController.dispose();
    _nextOfKinController.dispose();
    _saidController.dispose();
    _workerpinController.dispose();
    _childrenNamesController.dispose();
    _parentDetailsController.dispose();
    super.dispose();
  }
}
