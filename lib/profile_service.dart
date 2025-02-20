// profile_service.dart
// ignore_for_file: use_build_context_synchronously

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
  Future<Map<String, bool>> getUserProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isProfileSaved': prefs.getBool('isProfileSaved') ?? false,
      'isDocumentsUploaded': prefs.getBool('isDocumentsUploaded') ?? false,
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
    if (!formKey.currentState!.validate()) return;

    onLoadingChanged(true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final String userId = user.id;
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

      await supabase.from('profiles').upsert(updates);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isProfileSaved', true);

      onProfileSavedChanged(true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UploadDocuments()),
      );
    } finally {
      onLoadingChanged(false);
    }
  }
}
