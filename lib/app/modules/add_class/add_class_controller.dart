import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddClassController extends GetxController {
  final classNameController = TextEditingController();
  final establishmentController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedLevel = Rxn<String>();
  final selectedSubject = Rxn<String>();

  final levels = <String>[
    "6ème",
    "5ème",
    "4ème",
    "3ème",
    "2nde",
    "1ère",
    "Tle",
  ];

  final subjects = <String>[
    "Mathématiques",
    "Physique",
    "Histoire",
    "Anglais",
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    classNameController.dispose();
    establishmentController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void goBack() {
    Get.back();
  }

  void createClass() {
    if (classNameController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir le nom de la classe',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedLevel.value == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un niveau scolaire',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedSubject.value == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner une matière',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Redirection vers la page d'invitation
    Get.offNamed('/class-invitation-from-teacher');
  }
}
