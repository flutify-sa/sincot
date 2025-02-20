// profile_page.dart
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sincot/profile_controllers.dart';
import 'package:sincot/profile_service.dart';
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
  final ProfileControllers _controllers = ProfileControllers();
  final ProfileService _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isProfileSaved = false;
  String? _selectedRaceGender;

  @override
  void initState() {
    super.initState();
    _loadProfileState();
  }

  Future<void> _loadProfileState() async {
    final isSaved = await _profileService.loadProfileState();
    setState(() {
      _isProfileSaved = isSaved;
    });
  }

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  void _setProfileSaved(bool value) {
    setState(() {
      _isProfileSaved = value;
    });
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
                  nameController: _controllers.nameController,
                  surnameController: _controllers.surnameController,
                  mobileController: _controllers.mobileController,
                  addressControllerStreet: _controllers.addressControllerStreet,
                  addressControllerTown: _controllers.addressControllerTown,
                  addressControllerCode: _controllers.addressControllerCode,
                  bankDetailsControllerBank:
                      _controllers.bankDetailsControllerBank,
                  bankDetailsControllerAccount:
                      _controllers.bankDetailsControllerAccount,
                  bankDetailsControllerType:
                      _controllers.bankDetailsControllerType,
                  nextOfKinController: _controllers.nextOfKinController,
                  saidController: _controllers.saidController,
                  workerpinController: _controllers.workerpinController,
                  childrenNamesController1:
                      _controllers.childrenNamesController1,
                  childrenNamesController2:
                      _controllers.childrenNamesController2,
                  childrenNamesController3:
                      _controllers.childrenNamesController3,
                  parentDetailsController1:
                      _controllers.parentDetailsController1,
                  parentDetailsController2:
                      _controllers.parentDetailsController2,
                  motherinlaw: _controllers.motherinlaw,
                  fatherinlaw: _controllers.fatherinlaw,
                  immediatefamily: _controllers.immediatefamily,
                  selectedRaceGender: _selectedRaceGender,
                  raceGenders: ProfileConstants.raceGenders,
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
                      onSave: () => _profileService.saveProfileToSupabase(
                        formKey: _formKey,
                        controllers: _controllers,
                        selectedRaceGender: _selectedRaceGender,
                        context: context,
                        onLoadingChanged: _setLoading,
                        onProfileSavedChanged: _setProfileSaved,
                      ),
                      workerPin: _controllers.workerpinController.text.trim(),
                    ),
              AcceptanceCard(
                  workerpinController: _controllers.workerpinController),
              WhatsappCard(messageController: _controllers.messageController),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.dispose();
    super.dispose();
  }
}
