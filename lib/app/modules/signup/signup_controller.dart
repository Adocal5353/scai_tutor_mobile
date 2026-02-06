import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';
import 'package:scai_tutor_mobile/app/data/repositories/apprenant_repository.dart';
import 'package:scai_tutor_mobile/app/data/repositories/enseignant_repository.dart';
import 'package:scai_tutor_mobile/app/data/repositories/parent_repository.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/data/services/auth_service.dart';
import 'package:scai_tutor_mobile/app/data/models/user.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Services & Repositories
  final ApprenantRepository _apprenantRepository = ApprenantRepository();
  final EnseignantRepository _enseignantRepository = EnseignantRepository();
  final ParentRepository _parentRepository = ParentRepository();
  final UserService _userService = Get.find<UserService>();
  final AuthService _authService = Get.find<AuthService>();

  // Text Controllers
  final nameController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final etablissementController = TextEditingController();
  final telephoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables
  final RxBool isLoading = false.obs;
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

  Future<void> createAccount() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedProfile.value.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un profil',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      Map<String, dynamic> response;
      String userType;

      // Extraire nom et prénom du nameController
      final fullName = nameController.text.trim();
      final nameParts = fullName.split(' ');
      final nom = nameParts.isNotEmpty ? nameParts.first : fullName;
      final prenom = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      switch (selectedProfile.value) {
        case 'learner':
          response = await _apprenantRepository.create(
            nom: nom,
            prenom: prenom,
            email: emailController.text.trim(),
            password: passwordController.text,
            passwordConfirmation: confirmPasswordController.text,
            niveauScolaire: niveau.value,
            telephone: telephoneController.text.trim().isNotEmpty 
              ? telephoneController.text.trim() 
              : null,
          );
          userType = 'apprenant';
          break;

        case 'teacher':
          response = await _enseignantRepository.create(
            nom: nom,
            prenom: prenom,
            email: emailController.text.trim(),
            password: passwordController.text,
            passwordConfirmation: confirmPasswordController.text,
            specialite: specialite.value,
            etablissement: etablissementController.text.trim().isNotEmpty 
              ? etablissementController.text.trim() 
              : null,
            telephone: telephoneController.text.trim().isNotEmpty 
              ? telephoneController.text.trim() 
              : null,
          );
          userType = 'enseignant';
          break;

        case 'parent':
          response = await _parentRepository.create(
            nom: nom,
            prenom: prenom,
            email: emailController.text.trim(),
            password: passwordController.text,
            passwordConfirmation: confirmPasswordController.text,
            telephone: telephoneController.text.trim().isNotEmpty 
              ? telephoneController.text.trim() 
              : null,
          );
          userType = 'parent';
          break;

        default:
          throw Exception('Profil non valide');
      }

      // LOG: Vérifier la réponse avant de créer l'utilisateur
      print('[SignupController] Réponse reçue du repository:');
      print('   - Type: ${response.runtimeType}');
      print('   - Contenu: $response');
      print('   - Keys disponibles: ${response.keys}');
      
      // Vérifier si on a un ID dans la réponse
      final hasId = response.containsKey('id') || response.containsKey('_id') || 
                    response.containsKey('id_apprenant') || response.containsKey('id_enseignant') || 
                    response.containsKey('id_parent');
      
      print('   - A un ID: $hasId');
      print('   - Valeurs: id=${response['id'] ?? response['_id']}, nom=${response['nom']}, prenom=${response['prenom']}, email=${response['email']}');

      // Récupérer le token si présent dans la réponse
      final token = response['token'] as String?;

      if (!hasId || token == null) {
        // Si pas d'ID ou pas de token (cas du 204 No Content), faire un login automatique
        print('[SignupController] Pas d\'ID ou de token, login automatique...');
        await _authService.login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      } else {
        // Créer l'objet User depuis la réponse
        final user = _createUserFromResponse(response, userType);
        
        // Stocker l'utilisateur
        _userService.setUser(user, token: token, userType: userType);
      }

      Get.snackbar(
        'Succès',
        'Compte créé avec succès !',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.1),
      );

      // Navigation selon le profil
      _navigateByProfile();
    } catch (e) {
      // Vérifier que le controller n'est pas disposé avant d'afficher l'erreur
      if (!isClosed) {
        Get.snackbar(
          'Erreur',
          e.toString().replaceAll('Exception: ', ''),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
          duration: const Duration(seconds: 4),
        );
      }
    } finally {
      // Vérifier que le controller n'est pas disposé avant de modifier les observables
      if (!isClosed) {
        isLoading.value = false;
      }
    }
  }

  User _createUserFromResponse(Map<String, dynamic> response, String userType) {
    print('[SignupController] _createUserFromResponse appelée:');
    print('   - response type: ${response.runtimeType}');
    print('   - userType: $userType');
    
    // Mapper le type API vers le rôle app
    String role;
    switch (userType) {
      case 'apprenant':
        role = 'learner';
        break;
      case 'enseignant':
        role = 'teacher';
        break;
      case 'parent':
        role = 'parent';
        break;
      default:
        role = userType;
    }

    // Extraire l'ID avec vérification de type
    final id = response['_id']?.toString() ?? response['id']?.toString() ?? '';
    final prenom = response['prenom']?.toString() ?? '';
    final nom = response['nom']?.toString() ?? '';
    final email = response['email']?.toString() ?? '';
    final photoUrl = response['photo_url']?.toString() ?? '';
    
    print('   - Valeurs extraites: id=$id, prenom=$prenom, nom=$nom, email=$email');

    return User(
      id: id,
      role: role,
      name: '$prenom $nom'.trim(),
      email: email,
      imageUrl: photoUrl,
    );
  }

  void _navigateByProfile() {
    switch (selectedProfile.value) {
      case 'learner':
        Get.offAllNamed(Routes.DASHBOARD_STUDENT);
        break;
      case 'teacher':
        Get.offAllNamed(Routes.DASHBOARD_TEACHER);
        break;
      case 'parent':
        Get.offAllNamed(Routes.PARENT_GUARDIAN);
        break;
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
    prenomController.dispose();
    telephoneController.dispose();
    emailController.dispose();
    etablissementController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
