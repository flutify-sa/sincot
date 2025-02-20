// profile_controllers.dart
import 'package:flutter/material.dart';

class ProfileControllers {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController addressControllerStreet = TextEditingController();
  final TextEditingController addressControllerTown = TextEditingController();
  final TextEditingController addressControllerCode = TextEditingController();
  final TextEditingController bankDetailsControllerBank =
      TextEditingController();
  final TextEditingController bankDetailsControllerAccount =
      TextEditingController();
  final TextEditingController bankDetailsControllerType =
      TextEditingController();
  final TextEditingController nextOfKinController = TextEditingController();
  final TextEditingController saidController = TextEditingController();
  final TextEditingController workerpinController = TextEditingController();
  final TextEditingController childrenNamesController1 =
      TextEditingController();
  final TextEditingController childrenNamesController2 =
      TextEditingController();
  final TextEditingController childrenNamesController3 =
      TextEditingController();
  final TextEditingController parentDetailsController1 =
      TextEditingController();
  final TextEditingController parentDetailsController2 =
      TextEditingController();
  final TextEditingController motherinlaw = TextEditingController();
  final TextEditingController fatherinlaw = TextEditingController();
  final TextEditingController immediatefamily = TextEditingController();

  void dispose() {
    messageController.dispose();
    nameController.dispose();
    mobileController.dispose();
    surnameController.dispose();
    idController.dispose();
    addressControllerStreet.dispose();
    addressControllerTown.dispose();
    addressControllerCode.dispose();
    bankDetailsControllerBank.dispose();
    bankDetailsControllerAccount.dispose();
    bankDetailsControllerType.dispose();
    nextOfKinController.dispose();
    saidController.dispose();
    workerpinController.dispose();
    childrenNamesController1.dispose();
    childrenNamesController2.dispose();
    childrenNamesController3.dispose();
    parentDetailsController1.dispose();
    parentDetailsController2.dispose();
    motherinlaw.dispose();
    fatherinlaw.dispose();
    immediatefamily.dispose();
  }
}

class ProfileConstants {
  static const List<String> raceGenders = [
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
}
