// profile_form.dart
import 'package:flutter/material.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController mobileController;
  final TextEditingController addressControllerStreet;
  final TextEditingController addressControllerTown;
  final TextEditingController addressControllerCode;
  final TextEditingController bankDetailsControllerBank;
  final TextEditingController bankDetailsControllerAccount;
  final TextEditingController bankDetailsControllerType;
  final TextEditingController nextOfKinController;
  final TextEditingController saidController;
  final TextEditingController workerpinController;
  final TextEditingController childrenNamesController1;
  final TextEditingController childrenNamesController2;
  final TextEditingController childrenNamesController3;
  final TextEditingController parentDetailsController1;
  final TextEditingController parentDetailsController2;
  final TextEditingController motherinlaw;
  final TextEditingController fatherinlaw;
  final TextEditingController immediatefamily;
  final String? selectedRaceGender;
  final List<String> raceGenders;
  final ValueChanged<String?> onRaceGenderChanged;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.surnameController,
    required this.mobileController,
    required this.addressControllerStreet,
    required this.addressControllerTown,
    required this.addressControllerCode,
    required this.bankDetailsControllerBank,
    required this.bankDetailsControllerAccount,
    required this.bankDetailsControllerType,
    required this.nextOfKinController,
    required this.saidController,
    required this.workerpinController,
    required this.childrenNamesController1,
    required this.childrenNamesController2,
    required this.childrenNamesController3,
    required this.parentDetailsController1,
    required this.parentDetailsController2,
    required this.motherinlaw,
    required this.fatherinlaw,
    required this.immediatefamily,
    required this.selectedRaceGender,
    required this.raceGenders,
    required this.onRaceGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Text(
            'Fill in ALL the fields below.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xffe6cf8c),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 25),
          TextFormField(
            controller: nameController,
            decoration: _inputDecoration('Enter your Name'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your name'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: surnameController,
            decoration: _inputDecoration('Enter your Surname'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your surname'
                : null,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: selectedRaceGender,
            hint: Text('Select Race and Gender'),
            items: raceGenders.map((String raceGender) {
              return DropdownMenuItem<String>(
                value: raceGender,
                child: Text(raceGender),
              );
            }).toList(),
            onChanged: onRaceGenderChanged,
            validator: (value) =>
                value == null ? 'Please select a race and gender' : null,
            decoration: InputDecoration(
              fillColor: Color(0xffe6cf8c),
              filled: true,
              border: OutlineInputBorder(),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: mobileController,
            decoration: _inputDecoration('Enter your Mobile Number'),
            style: TextStyle(fontSize: 14),
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
            controller: addressControllerStreet,
            decoration: _inputDecoration('Street Address'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your street address'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: addressControllerTown,
            decoration: _inputDecoration('Town'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your town'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: addressControllerCode,
            decoration: _inputDecoration('Postal Code'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your postal code'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: bankDetailsControllerBank,
            decoration: _inputDecoration('Bank Name'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your bank name'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: bankDetailsControllerAccount,
            decoration: _inputDecoration('Account Number'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your account number'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: bankDetailsControllerType,
            decoration: _inputDecoration('Account Type'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your account type'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: nextOfKinController,
            decoration: _inputDecoration('Spouse'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter spouse details'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: fatherinlaw,
            decoration: _inputDecoration('Father In Law'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter Father in law details'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: motherinlaw,
            decoration: _inputDecoration('Mother In Law'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter Mother in law details'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: saidController,
            decoration: _inputDecoration('ID Number'),
            style: TextStyle(fontSize: 14),
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
            controller: workerpinController,
            decoration: _inputDecoration('Worker PIN'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter your worker PIN'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: childrenNamesController1,
            decoration: _inputDecoration('Child 1 Name'),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: childrenNamesController2,
            decoration: _inputDecoration('Child 2 Name'),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: childrenNamesController3,
            decoration: _inputDecoration('Child 3 Name'),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: parentDetailsController1,
            decoration: _inputDecoration('Parent 1 Name'),
            style: TextStyle(fontSize: 14),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter the name of the first parent'
                : null,
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: parentDetailsController2,
            decoration: _inputDecoration('Parent 2 Name'),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 16),
          TextFormField(
            controller: immediatefamily,
            decoration: _inputDecoration('Immediate Family'),
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      fillColor: Color(0xffe6cf8c),
      filled: true,
    );
  }
}
