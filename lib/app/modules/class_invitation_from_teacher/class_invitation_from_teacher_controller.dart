import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/invitation_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/apprenant_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/models/apprenant_model.dart';

class ClassInvitationFromTeacherController extends GetxController {
  final InvitationProvider _invitationProvider = InvitationProvider(Get.find<ApiProvider>());
  final ApprenantProvider _apprenantProvider = ApprenantProvider(Get.find<ApiProvider>());
  final ClasseProvider _classeProvider = ClasseProvider(Get.find<ApiProvider>());
  
  // Informations de la classe
  final className = 'Classe de Physiques'.obs;
  final classLevel = ''.obs;
  final classeId = ''.obs;
  
  // Form controllers pour recherche
  final searchEmailController = TextEditingController();
  
  // Form controllers pour invitation
  final inviteEmailController = TextEditingController();
  final inviteNomController = TextEditingController();
  final invitePrenomController = TextEditingController();
  
  // États
  final RxBool isSearching = false.obs;
  final RxBool isInviting = false.obs;
  final RxList<ApprenantModel> searchResults = <ApprenantModel>[].obs;
  final RxBool hasSearched = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    print('[ClassInvitation] Arguments recus: $args');
    if (args != null) {
      className.value = args['className'] ?? 'Classe';
      classLevel.value = args['classLevel'] ?? '';
      classeId.value = args['classeId'] ?? '';
      print('[ClassInvitation] Classe: ${className.value}, Niveau: ${classLevel.value}, ID: "${classeId.value}"');
    }
  }

  @override
  void onClose() {
    searchEmailController.dispose();
    inviteEmailController.dispose();
    inviteNomController.dispose();
    invitePrenomController.dispose();
    super.onClose();
  }

  void goBack() {
    Get.back();
  }

  /// Rechercher un étudiant existant par email
  Future<void> searchStudent() async {
    final email = searchEmailController.text.trim();
    
    if (email.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un email valide',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isSearching.value = true;
      hasSearched.value = true;
      searchResults.clear();
      
      final response = await _apprenantProvider.getAll(
        params: {'email': email}
      );
      
      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        final allStudents = data
          .map((json) => ApprenantModel.fromJson(json as Map<String, dynamic>))
          .toList();
        
        // Filtre côté client pour compenser le backend
        searchResults.value = allStudents
          .where((student) => 
            student.email.toLowerCase().contains(email.toLowerCase())
          )
          .toList();
      }
      
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de rechercher l\'étudiant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isSearching.value = false;
    }
  }

  /// Ajouter un étudiant existant à la classe
  Future<void> addExistingStudent(ApprenantModel student) async {
    // Validation
    if (classeId.value.isEmpty) {
      Get.snackbar(
        'Erreur',
        'ID de classe manquant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    if (student.id == null || student.id!.isEmpty) {
      Get.snackbar(
        'Erreur',
        'ID de l\'étudiant manquant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isSearching.value = true;
      
      print('[ClassInvitation] Ajout etudiant:');
      print('  - classeId: ${classeId.value}');
      print('  - studentId: ${student.id}');
      print('  - student: ${student.nom} ${student.prenom}');
      
      final response = await _classeProvider.assignApprenants(
        classeId.value,
        [student.id!]
      );
      
      print('[ClassInvitation] Etudiant ajoute (status: ${response.statusCode})');
      
      Get.snackbar(
        'Succès',
        '${student.nom} ${student.prenom} a été ajouté à la classe',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      searchEmailController.clear();
      searchResults.clear();
      hasSearched.value = false;
      
    } catch (e) {
      print('[ClassInvitation] Erreur ajout etudiant: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'ajouter l\'étudiant: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isSearching.value = false;
    }
  }
  
  /// Inviter un nouvel étudiant par email
  Future<void> sendInvitation() async {
    final email = inviteEmailController.text.trim();
    final nom = inviteNomController.text.trim();
    final prenom = invitePrenomController.text.trim();
    
    if (email.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir l\'email de l\'élève',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir un email valide',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    try {
      isInviting.value = true;
      
      final data = {
        'email': email,
        'nom': nom.isNotEmpty ? nom : null,
        'prenom': prenom.isNotEmpty ? prenom : null,
        'type': 'apprenant',
        'id_classe': classeId.value,
      };
      
      await _invitationProvider.inviterApprenant(data);
      
      Get.snackbar(
        'Succès',
        'Invitation envoyée à $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
      
      // Réinitialiser les champs
      inviteEmailController.clear();
      inviteNomController.clear();
      invitePrenomController.clear();
      
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible d\'envoyer l\'invitation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isInviting.value = false;
    }
  }
}
