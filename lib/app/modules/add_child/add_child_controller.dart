import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/repositories/invitation_repository.dart';
import 'package:scai_tutor_mobile/app/data/repositories/apprenant_repository.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';

class AddChildController extends GetxController with GetSingleTickerProviderStateMixin {
  final InvitationRepository _invitationRepository = Get.find<InvitationRepository>();
  final ApprenantRepository _apprenantRepository = Get.find<ApprenantRepository>();
  final UserService _userService = Get.find<UserService>();

  late TabController tabController;

  // Invitation Form Controllers
  final TextEditingController inviteNomController = TextEditingController();
  final TextEditingController invitePrenomController = TextEditingController();
  final TextEditingController inviteEmailController = TextEditingController();

  // Direct Creation Form Controllers
  final TextEditingController createNomController = TextEditingController();
  final TextEditingController createPrenomController = TextEditingController();
  final TextEditingController createEmailController = TextEditingController();
  final TextEditingController createPasswordController = TextEditingController();
  final TextEditingController createPasswordConfirmController = TextEditingController();

  // Selected niveau scolaire for direct creation
  final Rxn<String> selectedNiveau = Rxn<String>();
  
  final List<String> niveauxScolaires = [
    'Primaire',
    'Collège',
    'Lycée',
    'Université',
  ];

  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscurePasswordConfirm = true.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void togglePasswordConfirmVisibility() {
    obscurePasswordConfirm.value = !obscurePasswordConfirm.value;
  }

  // Send invitation to existing child
  Future<void> sendInvitation() async {
    if (!_validateInvitationForm()) {
      return;
    }

    try {
      isLoading.value = true;

      final parentId = _userService.user?.id;
      if (parentId == null) {
        Get.snackbar(
          'Erreur',
          'Impossible d\'identifier le parent',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      print('[AddChild] Sending invitation from parent $parentId');

      await _invitationRepository.inviterApprenant(
        nom: inviteNomController.text.trim(),
        prenom: invitePrenomController.text.trim(),
        email: inviteEmailController.text.trim(),
        idParent: parentId,
      );

      print('[AddChild] Invitation sent successfully');

      Get.snackbar(
        'Succès',
        'Invitation envoyée à ${inviteEmailController.text.trim()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Return true to indicate success
      Get.back(result: true);
    } catch (e) {
      print('[AddChild] Error sending invitation: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'envoyer l\'invitation',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create child account directly
  Future<void> createChildAccount() async {
    if (!_validateCreateForm()) {
      return;
    }

    try {
      isLoading.value = true;

      final parentId = _userService.user?.id;
      if (parentId == null) {
        Get.snackbar(
          'Erreur',
          'Impossible d\'identifier le parent',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      print('[AddChild] Creating child account for parent $parentId');

      // Create apprenant account
      await _apprenantRepository.create(
        nom: createNomController.text.trim(),
        prenom: createPrenomController.text.trim(),
        email: createEmailController.text.trim(),
        password: createPasswordController.text.trim(),
        passwordConfirmation: createPasswordConfirmController.text.trim(),
        niveauScolaire: selectedNiveau.value,
        // Note: Backend should handle linking to parent via id_parent in request
        // Or we may need to make another API call to link them
      );

      print('[AddChild] Child account created successfully');

      Get.snackbar(
        'Succès',
        'Compte enfant créé avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Return true to indicate success
      Get.back(result: true);
    } catch (e) {
      print('[AddChild] Error creating child account: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de créer le compte enfant',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInvitationForm() {
    if (inviteNomController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir le nom de l\'enfant',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (invitePrenomController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir le prénom de l\'enfant',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (inviteEmailController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir l\'email de l\'enfant',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(inviteEmailController.text.trim())) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir un email valide',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  bool _validateCreateForm() {
    if (createNomController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir le nom de l\'enfant',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (createPrenomController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir le prénom de l\'enfant',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (createEmailController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir l\'email de l\'enfant',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(createEmailController.text.trim())) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir un email valide',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (createPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir un mot de passe',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (createPasswordController.text.trim().length < 8) {
      Get.snackbar(
        'Validation',
        'Le mot de passe doit contenir au moins 8 caractères',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (createPasswordController.text.trim() != createPasswordConfirmController.text.trim()) {
      Get.snackbar(
        'Validation',
        'Les mots de passe ne correspondent pas',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    tabController.dispose();
    inviteNomController.dispose();
    invitePrenomController.dispose();
    inviteEmailController.dispose();
    createNomController.dispose();
    createPrenomController.dispose();
    createEmailController.dispose();
    createPasswordController.dispose();
    createPasswordConfirmController.dispose();
    super.onClose();
  }
}
