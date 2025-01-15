// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sincot/authservice.dart'; // Assuming this handles authentication
import 'package:sincot/loginpage.dart';
import 'package:sincot/profilebutton.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Authservice _authService = Authservice();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bankDetailsController = TextEditingController();
  final TextEditingController _nextOfKinController = TextEditingController();

  bool _isProfileUpdated = false;
  String _userEmail = ''; // This will store the user's registered email

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Load profile data from shared preferences and auth service
  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String email = _authService.getCurrentUserEmail() ?? '';

    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _surnameController.text = prefs.getString('surname') ?? '';
      _mobileController.text = prefs.getString('mobile') ?? '';
      _idController.text = prefs.getString('id') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _bankDetailsController.text = prefs.getString('bankDetails') ?? '';
      _nextOfKinController.text = prefs.getString('nextOfKin') ?? '';
      _userEmail = email;
      _isProfileUpdated = prefs.getString('name') != null;
    });
  }

  // Save profile data to shared preferences
  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('surname', _surnameController.text);
    await prefs.setString('mobile', _mobileController.text);
    await prefs.setString('id', _idController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('bankDetails', _bankDetailsController.text);
    await prefs.setString('nextOfKin', _nextOfKinController.text);

    _loadProfile(); // Reload profile data after saving
  }

  Future<void> _showEditProfileDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Name'),
                ),
                TextField(
                  controller: _surnameController,
                  decoration: InputDecoration(hintText: 'Surname'),
                ),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'ID'),
                ),
                TextField(
                  controller: _addressController,
                  maxLines: 3, // Multiline
                  decoration: InputDecoration(hintText: 'Address'),
                ),
                TextField(
                  controller: _bankDetailsController,
                  maxLines: 3, // Multiline
                  decoration: InputDecoration(hintText: 'Bank Details'),
                ),
                TextField(
                  controller: _nextOfKinController,
                  decoration: InputDecoration(hintText: 'Next of Kin'),
                ),
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Mobile',
                    prefixText: '+27 ',
                    errorText: _validateMobileNumber(_mobileController.text)
                        ? null
                        : 'Invalid phone number',
                  ),
                  maxLength:
                      9, // South African numbers allow 9 digits after +27
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[0-9]')), // Allow only numbers
                  ],
                  onChanged: (value) {
                    // Ensure the user cannot input a leading zero
                    if (value.startsWith('0')) {
                      _mobileController.text =
                          value.substring(1); // Remove leading zero
                      _mobileController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _mobileController.text.length),
                      );
                    }
                  },
                ),
                TextField(
                  controller: TextEditingController(text: _userEmail),
                  decoration: InputDecoration(hintText: 'Email'),
                  enabled: false, // Email field is not editable
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_validateMobileNumber(_mobileController.text)) {
                  await _saveProfile(); // Save profile and update UI
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid mobile number')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _validateMobileNumber(String mobile) {
    // Add +27 prefix dynamically for validation purposes
    if (!mobile.startsWith('+27')) {
      mobile = '+27$mobile';
    }

    final RegExp mobileRegExp = RegExp(r'^\+27[0-9]{9}$');
    return mobileRegExp.hasMatch(mobile);
  }

  // Logout method
  Future<void> logout() async {
    try {
      await _authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged out successfully')),
        );
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage(onTap: () {})),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Profile Page',
          style: TextStyle(color: Color(0xffe6cf8c)),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.logout, size: 30, color: Color(0xffe6cf8c)),
              onPressed: logout,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isProfileUpdated) ...[
              // Card with profile data
              Card(
                color: Color(0xff2c2c2c), // Dark card color
                elevation: 4, // Card shadow
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Full Name: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 16),
                          ),
                          Text(
                            '${_nameController.text} ${_surnameController.text}',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'ID: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 16),
                          ),
                          Text(
                            _idController.text,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Address:',
                        style:
                            TextStyle(color: Color(0xffe6cf8c), fontSize: 16),
                      ),
                      Text(
                        _addressController.text,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bank Details:',
                        style:
                            TextStyle(color: Color(0xffe6cf8c), fontSize: 16),
                      ),
                      Text(
                        _bankDetailsController.text,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Next of Kin: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 16),
                          ),
                          Text(
                            _nextOfKinController.text,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Mobile: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 16),
                          ),
                          Text(
                            '0${_mobileController.text}', // Prepend 0 for display
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Email: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 16),
                          ),
                          Text(
                            _userEmail,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Spacer(),
            MyProfileButton(
              onTap: _showEditProfileDialog,
              text: 'Edit Profile',
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
