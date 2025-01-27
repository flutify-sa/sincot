// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sincot/authservice.dart';
import 'package:sincot/loginpage.dart';
import 'package:sincot/profilebutton.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:sincot/local.dart'; // Import LocalContractPage
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final TextEditingController _saidController = TextEditingController();
  final TextEditingController _workerpinController = TextEditingController();
  final TextEditingController _childrenNamesController =
      TextEditingController();
  final TextEditingController _parentDetailsController =
      TextEditingController();

  bool _isProfileUpdated = true;
  bool _isLocalContractButtonActive = false; // New state for button activation
  String _userEmail = ''; // This will store the user's registered email

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _saveProfileToSupabase() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    // Directly insert or update the profile data without any checks or error handling
    await supabase.from('profiles').upsert([
      {
        'user_id': user!.id,
        'name': _nameController.text,
        'surname': _surnameController.text,
        'mobile_number': _mobileController.text,
        'address': _addressController.text,
        'bank_details': _bankDetailsController.text,
        'next_of_kin': _nextOfKinController.text,
        'said': _saidController.text,
        'workerpin': _workerpinController.text,
        'children_names': _childrenNamesController.text,
        'parent_details': _parentDetailsController.text,
      }
    ]);

    // Success notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile saved/updated successfully!')),
    );

    // Enable the Local Contract button after saving
    setState(() {
      _isLocalContractButtonActive = true;
    });
  }

  // Load profile data from shared preferences and auth service
  Future<void> _loadProfile() async {
    String email = _authService.getCurrentUserEmail() ?? '';

    // Get profile data from Supabase
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) {
      // Handle the case where user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User is not authenticated')),
      );
      return;
    }

    try {
      // Fetch the user's profile from Supabase
      final response = await supabase
          .from('profiles')
          .select()
          .eq('user_id', user.id)
          .single(); // Fetch a single record

      setState(() {
        _nameController.text = response['name'] ?? '';
        _surnameController.text = response['surname'] ?? '';
        _workerpinController.text = response['workerpin'] ?? '';
        _mobileController.text = response['mobile_number'] ?? '';
        _saidController.text = response['id'] ?? '';
        _addressController.text = response['address'] ?? '';
        _bankDetailsController.text = response['bank_details'] ?? '';
        _nextOfKinController.text = response['next_of_kin'] ?? '';
        _userEmail = email;
        _saidController.text = response['said'] ?? '';
        _childrenNamesController.text = response['children_names'] ?? '';
        _parentDetailsController.text = response['parent_details'] ?? '';
        _isProfileUpdated = true; // Profile is updated when we get data
      });
    } catch (e) {
      // Handle the case where no profile is found
      if (e is PostgrestException && e.code == 'PGRST116') {
        // Handle the specific case where no profile data is found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No profile data found for the user')),
        );
      } else {
        // Handle any other errors that might occur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  // Save profile data to shared preferences
  // ignore: unused_element
  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save profile data to SharedPreferences (local storage)
    await prefs.setString('name', _nameController.text);
    await prefs.setString('surname', _surnameController.text);
    await prefs.setString('mobile_number', _mobileController.text);
    await prefs.setString('id', _idController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('bankDetails', _bankDetailsController.text);
    await prefs.setString('nextOfKin', _nextOfKinController.text);
    await prefs.setString('said', _saidController.text);
    await prefs.setString('workerpin', _workerpinController.text);
    await prefs.setString('children_names', _childrenNamesController.text);
    await prefs.setString('parent_details', _parentDetailsController.text);

    // Now save or update the profile data to Supabase
    await _saveProfileToSupabase();

    _loadProfile(); // Reload profile data after saving
  }

  Future<void> _showEditProfileDialog() async {
    final updatedData = await showDialog<Map<String, String>>(
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
                // Other fields remain unchanged
                TextField(
                  controller: _workerpinController,
                  decoration: InputDecoration(hintText: 'Pin Number'),
                ),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'ID'),
                ),
                TextField(
                  controller: _saidController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(hintText: 'Confirm ID'),
                ),
                TextField(
                  controller: _addressController,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: 'Address'),
                ),
                TextField(
                  controller: _childrenNamesController,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: 'Children Names'),
                ),
                TextField(
                  controller: _parentDetailsController,
                  maxLines: 3,
                  decoration: InputDecoration(hintText: 'Parent Details'),
                ),
                TextField(
                  controller: _bankDetailsController,
                  maxLines: 3,
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
                  maxLength: 9,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onChanged: (value) {
                    if (value.startsWith('0')) {
                      _mobileController.text = value.substring(1);
                      _mobileController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _mobileController.text.length),
                      );
                    }
                  },
                ),
                TextField(
                  controller: TextEditingController(text: _userEmail),
                  decoration: InputDecoration(hintText: 'Email'),
                  enabled: false,
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
              onPressed: () {
                if (_validateMobileNumber(_mobileController.text)) {
                  // Save profile to memory
                  final profileData = {
                    'name': _nameController.text,
                    'surname': _surnameController.text,
                    'mobile': _mobileController.text,
                  };

                  // Pass data back to previous screen
                  Navigator.pop(context, profileData);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid mobile number')),
                  );
                }
              },
              child: Text('Save'),
            )
          ],
        );
      },
    );

    if (updatedData != null) {
      // Update the state with the new name and surname
      setState(() {
        _nameController.text = updatedData['name'] ?? _nameController.text;
        _surnameController.text =
            updatedData['surname'] ?? _surnameController.text;
        _workerpinController.text =
            updatedData['workerpin'] ?? _workerpinController.text;
        _mobileController.text =
            updatedData['mobile_number'] ?? _mobileController.text;
        _idController.text = updatedData['id'] ?? _idController.text;
        _addressController.text =
            updatedData['address'] ?? _addressController.text;
        _bankDetailsController.text =
            updatedData['bank_details'] ?? _bankDetailsController.text;
        _nextOfKinController.text =
            updatedData['next_of_kin'] ?? _nextOfKinController.text;
        _saidController.text = updatedData['said'] ?? _saidController.text;
        _childrenNamesController.text =
            updatedData['children_names'] ?? _childrenNamesController.text;
        _parentDetailsController.text =
            updatedData['parent_details'] ?? _parentDetailsController.text;
      });

      // Enable the Local Contract button after saving
      setState(() {
        _isLocalContractButtonActive = true;
      });

      // Navigate to LocalContractPage with the updated name and surname
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocalContractPage(
            name: updatedData['name']!,
            surname: updatedData['surname']!,
            mobile: _mobileController.text,
            id: _idController.text,
            address: _addressController.text,
            bankDetails: _bankDetailsController.text,
            nextOfKin: _nextOfKinController.text,
            said: _saidController.text,
            workerpin: _workerpinController.text,
            childrenNames: _childrenNamesController.text,
            parentDetails: _parentDetailsController.text,
          ),
        ),
      );
    }
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
          style: TextStyle(
            color: Color(0xffe6cf8c),
          ),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Align from the top
          children: [
            if (_isProfileUpdated) ...[
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
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Text(
                            '${_nameController.text} ${_surnameController.text}',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        // Use Column to stack ID and Pin vertically
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'ID: ',
                                style: TextStyle(
                                    color: Color(0xffe6cf8c), fontSize: 14),
                              ),
                              Text(
                                _saidController.text,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space between ID and Pin
                          Row(
                            children: [
                              Text(
                                'Children Names: ',
                                style: TextStyle(
                                    color: Color(0xffe6cf8c), fontSize: 14),
                              ),
                              Text(
                                _childrenNamesController.text,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space between ID and Pin

                          Row(
                            children: [
                              Text(
                                'Parents Info: ',
                                style: TextStyle(
                                    color: Color(0xffe6cf8c), fontSize: 14),
                              ),
                              Text(
                                _parentDetailsController.text,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Address:',
                        style:
                            TextStyle(color: Color(0xffe6cf8c), fontSize: 14),
                      ),
                      Text(
                        _addressController.text,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bank Details:',
                        style:
                            TextStyle(color: Color(0xffe6cf8c), fontSize: 14),
                      ),
                      Text(
                        _bankDetailsController.text,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Next of Kin: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Text(
                            _nextOfKinController.text,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Mobile: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Text(
                            '0${_mobileController.text}', // Prepend 0 for display
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Aligns content to the top
                        children: [
                          Text(
                            'Email: ',
                            style: TextStyle(
                                color: Color(0xffe6cf8c), fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              _userEmail,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              overflow: TextOverflow
                                  .ellipsis, // Optional: Adds "..." if text is too long
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
            SizedBox(height: 20), // Add spacing between sections
            MyProfileButton(
              onTap: _showEditProfileDialog,
              text: 'Edit Profile',
            ),
            SizedBox(height: 20), // Add spacing between sections
            MyProfileButton(
              onTap: () {
                // Navigate to UploadDocuments screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadDocuments()),
                );
              },
              text: 'Upload Documents',
            ),
            SizedBox(height: 20), // Add spacing between sections
            MyProfileButton(
              onTap: _isLocalContractButtonActive
                  ? () {
                      // Navigate to LocalContractPage and pass the profile data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocalContractPage(
                            name: _nameController.text,
                            surname: _surnameController.text,
                            mobile: _mobileController.text,
                            id: _idController.text,
                            address: _addressController.text,
                            bankDetails: _bankDetailsController.text,
                            nextOfKin: _nextOfKinController.text,
                            said: _saidController.text,
                            workerpin: _workerpinController.text,
                            childrenNames: _childrenNamesController.text,
                            parentDetails: _parentDetailsController.text,
                          ),
                        ),
                      );
                    }
                  : null, // Disable the button if not active
              text: 'Local Contract',
              isActive: _isLocalContractButtonActive, // Pass the state
            ),
          ],
        ),
      ),
    );
  }
}
