// profile_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sincot/profile_form.dart';
import 'package:sincot/action_buttons.dart';
import 'package:sincot/acceptance_card.dart';
import 'package:sincot/whatsapp_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final TextEditingController _messageController = TextEditingController();
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
  bool _isProfileSaved = false;
  String? _selectedRaceGender;
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

  @override
  void initState() {
    super.initState();
    _loadProfileState();
  }

  Future<void> _loadProfileState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isProfileSaved = prefs.getBool('isProfileSaved') ?? false;
    });
  }

  Future<void> _saveProfileToSupabase() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final String userId = user.id;
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

      final updates = {
        'user_id': userId,
        'name': name,
        'surname': surname,
        'mobile_number': mobile,
        'address': '$addressStreet, $addressTown, $addressCode',
        'bank_details':
            '$bankDetailsBank, $bankDetailsAccount, $bankDetailsType',
        'next_of_kin': nextOfKin,
        'said': said,
        'workerpin': workerpin,
        'children_names': '$childrenNames1, $childrenNames2, $childrenNames3',
        'parent_details': '$parentDetails1, $parentDetails2',
        'mother_in_law': motherinlaw,
        'father_in_law': fatherinlaw,
        'immediatefamily': immediatefamily,
        'racegender': _selectedRaceGender,
      };

      await supabase.from('profiles').upsert(updates);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isProfileSaved', true);

      setState(() {
        _isProfileSaved = true;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UploadDocuments()),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          child: Column(
            children: [
              if (!_isProfileSaved)
                ProfileForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  surnameController: _surnameController,
                  mobileController: _mobileController,
                  addressControllerStreet: _addressControllerStreet,
                  addressControllerTown: _addressControllerTown,
                  addressControllerCode: _addressControllerCode,
                  bankDetailsControllerBank: _bankDetailsControllerBank,
                  bankDetailsControllerAccount: _bankDetailsControllerAccount,
                  bankDetailsControllerType: _bankDetailsControllerType,
                  nextOfKinController: _nextOfKinController,
                  saidController: _saidController,
                  workerpinController: _workerpinController,
                  childrenNamesController1: _childrenNamesController1,
                  childrenNamesController2: _childrenNamesController2,
                  childrenNamesController3: _childrenNamesController3,
                  parentDetailsController1: _parentDetailsController1,
                  parentDetailsController2: _parentDetailsController2,
                  motherinlaw: _motherinlaw,
                  fatherinlaw: _fatherinlaw,
                  immediatefamily: _immediatefamily,
                  selectedRaceGender: _selectedRaceGender,
                  raceGenders: _raceGenders,
                  onRaceGenderChanged: (value) {
                    setState(() {
                      _selectedRaceGender = value;
                    });
                  },
                ),
              _isLoading
                  ? CircularProgressIndicator()
                  : ActionButtons(
                      isProfileSaved: _isProfileSaved,
                      onSave: _saveProfileToSupabase,
                      workerPin: _workerpinController.text.trim(),
                    ),
              AcceptanceCard(workerpinController: _workerpinController),
              WhatsappCard(messageController: _messageController),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _surnameController.dispose();
    _idController.dispose();
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
