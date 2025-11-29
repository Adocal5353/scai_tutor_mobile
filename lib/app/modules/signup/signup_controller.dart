import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final etablissementController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  final RxString selectedProfile = ''.obs;
  final RxBool hasStudent = false.obs;
  final RxString selectedTime = ''.obs;
  final RxnString niveau = RxnString();
  final RxnString specialite = RxnString();
  final RxnString selectedImagePath = RxnString();

  // Listes de données pour apprenant
  final List<String> niveauxEtude = [
    'Primaire',
    'Collège',
    'Lycée',
    'Université',
  ];

  // Listes de données pour enseignant
  final List<String> niveauxEnseignement = [
    'Primaire',
    'Collège',
    'Lycée',
    'Université',
  ];

  final List<String> specialites = [
    'Mathématiques',
    'Physique',
    'Histoire',
    'Français',
    'Anglais',
    'Sciences',
  ];

  // Getters pour obtenir la bonne liste selon le profil
  List<String> get niveaux {
    if (selectedProfile.value == 'teacher') {
      return niveauxEnseignement;
    } else if (selectedProfile.value == 'learner') {
      return niveauxEtude;
    }
    return [];
  }

  bool get showSpecialite => selectedProfile.value == 'teacher';

  String get niveauLabel {
    if (selectedProfile.value == 'teacher') {
      return "Niveau d'enseignement";
    } else if (selectedProfile.value == 'learner') {
      return "Niveau d'étude";
    }
    return "Niveau";
  }

  void selectTime(String value) {
    selectedTime.value = value;
  }

  void selectProfile(String value) {
    selectedProfile.value = value;
    // Réinitialiser niveau et spécialité quand on change de profil
    niveau.value = null;
    specialite.value = null;
  }

  void toggleHasStudent(bool value) {
    hasStudent.value = value;
  }

  void selectNiveau(String? value) {
    niveau.value = value;
  }

  void selectSpecialite(String? value) {
    specialite.value = value;
  }

  void uploadPhoto() {
    // TODO: Implémenter l'upload de photo
    Get.snackbar('Info', 'Fonctionnalité de téléversement de photo à implémenter');
  }

  void createAccount() {
    if (formKey.currentState!.validate()) {
      // Navigation selon le profil sélectionné
      if (selectedProfile.value == 'learner') {
        Get.offAllNamed(Routes.DASHBOARD_STUDENT);
      } else if (selectedProfile.value == 'teacher') {
        Get.offAllNamed(Routes.DASHBOARD_TEACHER);
      } else if (selectedProfile.value == 'parent') {
        Get.offAllNamed(Routes.PARENT_GUARDIAN);
      }
      Get.snackbar('Succès', 'Compte créé avec succès');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    etablissementController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
