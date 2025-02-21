// profile_service.dart
// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sincot/uploaddocuments.dart';
import 'package:flutter/material.dart';
import 'profile_controllers.dart';

class ProfileService {
  final SupabaseClient supabase = Supabase.instance.client;

  // Check if profile is saved
  Future<bool> loadProfileState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isProfileSaved') ?? false;
  }

  // New method to get user progress (profile and document status)
// profile_service.dart (snippet)
  Future<Map<String, bool>> getUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isProfileSaved': prefs.getBool('isProfileSaved') ?? false,
      'isDocumentsUploaded': prefs.getBool('isDocumentsUploaded') ?? false,
      'isContractViewed': prefs.getBool('isContractViewed') ?? false,
    };
  }

  Future<void> saveProfileToSupabase({
    required GlobalKey<FormState> formKey,
    required ProfileControllers controllers,
    required String? selectedRaceGender,
    required BuildContext context,
    required Function(bool) onLoadingChanged,
    required Function(bool) onProfileSavedChanged,
  }) async {
    print('Attempting to save profile...');
    if (!formKey.currentState!.validate()) {
      print('Form validation failed. Checking fields:');
      print('name: ${controllers.nameController.text}');
      print('surname: ${controllers.surnameController.text}');
      print('mobile: ${controllers.mobileController.text}');
      print('addressStreet: ${controllers.addressControllerStreet.text}');
      print('addressTown: ${controllers.addressControllerTown.text}');
      print('addressCode: ${controllers.addressControllerCode.text}');
      print('bankDetailsBank: ${controllers.bankDetailsControllerBank.text}');
      print(
          'bankDetailsAccount: ${controllers.bankDetailsControllerAccount.text}');
      print('bankDetailsType: ${controllers.bankDetailsControllerType.text}');
      print('nextOfKin: ${controllers.nextOfKinController.text}');
      print('said: ${controllers.saidController.text}');
      print('workerpin: ${controllers.workerpinController.text}');
      print('childrenNames1: ${controllers.childrenNamesController1.text}');
      print('childrenNames2: ${controllers.childrenNamesController2.text}');
      print('childrenNames3: ${controllers.childrenNamesController3.text}');
      print('parentDetails1: ${controllers.parentDetailsController1.text}');
      print('parentDetails2: ${controllers.parentDetailsController2.text}');
      print('motherinlaw: ${controllers.motherinlaw.text}');
      print('fatherinlaw: ${controllers.fatherinlaw.text}');
      print('immediatefamily: ${controllers.immediatefamily.text}');
      print('selectedRaceGender: $selectedRaceGender');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all required fields correctly')),
      );
      return;
    }

    print('Form validated successfully');
    onLoadingChanged(true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print('No authenticated user found');
        return;
      }

      final String userId = user.id;
      print('Saving profile for user: $userId');

      final String name = controllers.nameController.text.trim();
      final String surname = controllers.surnameController.text.trim();
      final String mobile = controllers.mobileController.text.trim();
      final String addressStreet =
          controllers.addressControllerStreet.text.trim();
      final String addressTown = controllers.addressControllerTown.text.trim();
      final String addressCode = controllers.addressControllerCode.text.trim();
      final String bankDetailsBank =
          controllers.bankDetailsControllerBank.text.trim();
      final String bankDetailsAccount =
          controllers.bankDetailsControllerAccount.text.trim();
      final String bankDetailsType =
          controllers.bankDetailsControllerType.text.trim();
      final String nextOfKin = controllers.nextOfKinController.text.trim();
      final String said = controllers.saidController.text.trim();
      final String workerpin = controllers.workerpinController.text.trim();
      final String childrenNames1 =
          controllers.childrenNamesController1.text.trim();
      final String childrenNames2 =
          controllers.childrenNamesController2.text.trim();
      final String childrenNames3 =
          controllers.childrenNamesController3.text.trim();
      final String parentDetails1 =
          controllers.parentDetailsController1.text.trim();
      final String parentDetails2 =
          controllers.parentDetailsController2.text.trim();
      final String motherinlaw = controllers.motherinlaw.text.trim();
      final String fatherinlaw = controllers.fatherinlaw.text.trim();
      final String immediatefamily = controllers.immediatefamily.text.trim();

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
        'racegender': selectedRaceGender,
      };

      print('Upserting profile to Supabase: $updates');
      await supabase.from('profiles').upsert(updates);
      print('Profile saved to Supabase successfully');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isProfileSaved', true);
      print('isProfileSaved set to true in SharedPreferences');

      final savedValue = prefs.getBool('isProfileSaved');
      print('Verified isProfileSaved after set: $savedValue');

      onProfileSavedChanged(true);

      print('Navigating to UploadDocuments');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UploadDocuments()),
      );
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      onLoadingChanged(false);
    }
  }
}
