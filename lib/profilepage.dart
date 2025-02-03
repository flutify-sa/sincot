// ignore_for_file: use_build_context_synchronously, avoid_print, unused_field, unused_local_variable
import 'package:flutter/material.dart';
import 'package:sincot/localcontract.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sincot/localacceptance.dart';

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

  final TextEditingController _addressControllerStreet =
      TextEditingController();
  final TextEditingController _addressControllerTown = TextEditingController();
  final TextEditingController _addressControllerCode = TextEditingController();

  final TextEditingController _bankDetailsControllerBank =
      TextEditingController();
  final TextEditingController _bankDetailsControllerAccount =
      TextEditingController();
  final TextEditingController _bankDetailsControllerType =
      TextEditingController();

  final TextEditingController _nextOfKinController = TextEditingController();
  final TextEditingController _saidController = TextEditingController();
  String? _selectedRaceGender; // Variable to hold the selected value
  final List<String> _raceGenders = [
    'Select Race and Gender',
    'African Male',
    'African Female',
    'Asian Male',
    'Asian Female',
    'Coloured Male',
    'Coloured Female',
    'Indian Male',
    'Indian Female',
    'White Male',
    'White Female',
  ];
  final TextEditingController _workerpinController = TextEditingController();
  final TextEditingController _childrenNamesController1 =
      TextEditingController();
  final TextEditingController _childrenNamesController2 =
      TextEditingController();
  final TextEditingController _childrenNamesController3 =
      TextEditingController();
  final TextEditingController _parentDetailsController1 =
      TextEditingController();
  final TextEditingController _parentDetailsController2 =
      TextEditingController();
  final TextEditingController _motherinlaw = TextEditingController();
  final TextEditingController _fatherinlaw = TextEditingController();
  final TextEditingController _immediatefamily = TextEditingController();
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
      final String addressStreet = _addressControllerStreet.text.trim();
      final String addressTown = _addressControllerTown.text.trim();
      final String addressCode = _addressControllerCode.text.trim();
      final String bankDetailsBank = _bankDetailsControllerBank.text.trim();
      final String bankDetailsAccount =
          _bankDetailsControllerAccount.text.trim();
      final String bankDetailsType = _bankDetailsControllerType.text.trim();
      final String nextOfKin = _nextOfKinController.text.trim();
      final String said = _saidController.text.trim();
      final String workerpin = _workerpinController.text.trim();
      final String childrenNames1 = _childrenNamesController1.text.trim();
      final String childrenNames2 = _childrenNamesController2.text.trim();
      final String childrenNames3 = _childrenNamesController3.text.trim();
      final String parentDetails1 = _parentDetailsController1.text.trim();
      final String parentDetails2 = _parentDetailsController2.text.trim();
      final String motherinlaw = _motherinlaw.text.trim();
      final String fatherinlaw = _fatherinlaw.text.trim();
      final String immediatefamily = _immediatefamily.text.trim();

      // Combine address fields into a single string
      final String fullAddress = '$addressStreet, $addressTown, $addressCode';

      // Combine children names into a single string
      final String fullChildrenNames =
          '$childrenNames1, $childrenNames2, $childrenNames3';

      // Combine parent details into a single string
      final String fullParentDetails = '$parentDetails1, $parentDetails2';

      // Combine bank details into a single string
      final String fullBankDetails =
          '$bankDetailsBank, $bankDetailsAccount, $bankDetailsType';

      final updates = {
        'user_id': userId,
        'name': name,
        'surname': surname,
        'mobile_number': mobile,
        'address': fullAddress,
        'bank_details': fullBankDetails, // Flattened structure
        'next_of_kin': nextOfKin,
        'said': said,
        'workerpin': workerpin,
        'children_names': fullChildrenNames,
        'parent_details': fullParentDetails,
        'mother_in_law': motherinlaw,
        'father_in_law': fatherinlaw,
        'immediatefamily': immediatefamily,
        'racegender': _selectedRaceGender,
      };

      print('Data being sent to Supabase: $updates');

      // Upsert the data without error checking
      final response = await supabase.from('profiles').upsert(updates);

      // Log success without checking for errors
      print('Success: ${response.data}');
      _showSuccessSnackBar('Profile updated successfully!');
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
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xffe6cf8c)),
        ),
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
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xffe6cf8c)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Enter your Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
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
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
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
                DropdownButtonFormField<String>(
                  value: _selectedRaceGender,
                  hint: Text('Select Race and Gender'),
                  items: _raceGenders.map((String raceGender) {
                    return DropdownMenuItem<String>(
                      value: raceGender,
                      child: Text(raceGender),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRaceGender =
                          newValue; // Update the selected value
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a race and gender' : null,
                  decoration: InputDecoration(
                    fillColor: Color(0xffe6cf8c), // Set the fill color
                    filled: true, // Enable the fill
                    border: OutlineInputBorder(), // Optional: Add a border
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12), // Optional: Adjust padding
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    labelText: 'Enter your Mobile Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
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
                  controller: _addressControllerStreet,
                  decoration: InputDecoration(
                    labelText: 'Street Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your street address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressControllerTown,
                  decoration: InputDecoration(
                    labelText: 'Town',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your town';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressControllerCode,
                  decoration: InputDecoration(
                    labelText: 'Postal Code',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your postal code';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bankDetailsControllerBank,
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your bank name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bankDetailsControllerAccount,
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your account number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _bankDetailsControllerType,
                  decoration: InputDecoration(
                    labelText: 'Account Type',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your account type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nextOfKinController,
                  decoration: InputDecoration(
                    labelText: 'Spouse',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter spouse details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _fatherinlaw,
                  decoration: InputDecoration(
                    labelText: 'Father In Law',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Father in law details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _motherinlaw,
                  decoration: InputDecoration(
                    labelText: 'Mother In Law',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mother in law details';
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
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
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
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
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
                  controller: _childrenNamesController1,
                  decoration: InputDecoration(
                    labelText: 'Child 1 Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _childrenNamesController2,
                  decoration: InputDecoration(
                    labelText: 'Child 2 Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _childrenNamesController3,
                  decoration: InputDecoration(
                    labelText: 'Child 3 Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _parentDetailsController1,
                  decoration: InputDecoration(
                    labelText: 'Parent 1 Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the name of the first parent';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _parentDetailsController2,
                  decoration: InputDecoration(
                    labelText: 'Parent 2 Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _immediatefamily,
                  decoration: InputDecoration(
                    labelText: 'Immediate Family',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    fillColor: Color(0xffe6cf8c),
                    filled: true,
                  ),
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10.0), // Margin around the card
                              color: Colors.grey
                                  .shade700, // Background color of the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // Optional: Rounded corners
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(
                                    16.0), // Padding inside the card

                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: _saveProfileToSupabase,
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        backgroundColor: Color(0xffe6cf8c),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                          borderRadius:
                                              BorderRadius.circular(6),
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
                                        final workerPin =
                                            _workerpinController.text.trim();
                                        if (workerPin.isEmpty) {
                                          _showErrorSnackBar(
                                              'Please enter your Worker PIN before proceeding.');
                                          return;
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Localcontract(
                                                workerPin: workerPin),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        backgroundColor:
                                            const Color(0xffe6cf8c),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: const Text(
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
                            ),
                          ],
                        ),
                      ),
                Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  color: Color(0xffe6cf8c), // Background color of the card
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Rounded corners
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(16.0), // Padding inside the card
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align text to the start
                      children: [
                        // TextField for user to input their worker pin
                        TextField(
                          controller: _workerpinController,
                          decoration: InputDecoration(
                            labelText: 'Enter your Worker Pin',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true, // Hide the pin input
                        ),
                        SizedBox(
                            height:
                                20), // Space between TextField and acceptance text
                        Text(
                          '1. I accept the Policies and procedures.\n2. I accept the Contract.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, // Text color
                          ),
                        ),
                        SizedBox(height: 10), // Space between text and button
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              // Get the current date and time
                              final currentDateTime = DateTime.now();
                              final formattedDateTime = currentDateTime
                                  .toIso8601String(); // Format as ISO 8601

                              final workerPin = _workerpinController.text;

                              print('Worker Pin: $workerPin');
                              print('Current DateTime: $formattedDateTime');

                              // Validate the worker pin
                              final response = await Supabase.instance.client
                                  .from('profiles')
                                  .select('workerpin')
                                  .eq('workerpin', workerPin)
                                  .single();

                              // Check if the worker pin exists
                              // Proceed with the update
                              await Supabase.instance.client
                                  .from('profiles')
                                  .update({
                                'acceptance':
                                    formattedDateTime, // Update the acceptance time
                              }).eq('workerpin', workerPin);

                              // Print confirmation
                              print('Acceptance time confirmed!');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              backgroundColor:
                                  Colors.black, // Button background color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    6), // Rounded corners for the button
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Confirm Acceptance',
                              style: TextStyle(
                                color: Color(0xffe6cf8c), // Button text color
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
    _addressControllerStreet.dispose();
    _addressControllerTown.dispose();
    _addressControllerCode.dispose();
    _bankDetailsControllerBank.dispose();
    _bankDetailsControllerAccount.dispose();
    _bankDetailsControllerType.dispose();
    _nextOfKinController.dispose();
    _saidController.dispose();
    _workerpinController.dispose();
    _childrenNamesController1.dispose();
    _childrenNamesController2.dispose();
    _childrenNamesController3.dispose();
    _parentDetailsController1.dispose();
    _parentDetailsController2.dispose();
    _motherinlaw.dispose();
    _fatherinlaw.dispose();
    _immediatefamily.dispose();
    super.dispose();
  }
}
