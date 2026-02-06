import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_teacher_content_view.dart';
import 'package:scai_tutor_mobile/app/modules/profile/profile_view.dart';
import 'package:scai_tutor_mobile/app/modules/class_teacher/class_teacher_view.dart';
import 'package:scai_tutor_mobile/app/modules/ressources_teacher/ressources_teacher_view.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/data/repositories/enseignant_repository.dart';
import 'package:scai_tutor_mobile/app/data/models/enseignant_model.dart';

class DashboardTeacherController extends GetxController {
  final UserService _userService = Get.find<UserService>();
  final EnseignantRepository _enseignantRepository = EnseignantRepository();
  
  var currentIndex = 0.obs;
  final Rxn<EnseignantModel> enseignant = Rxn<EnseignantModel>();
  final RxBool isLoading = false.obs;
  
  final List<Widget> pages = [
    const DashboardTeacherContentView(),
    const ClassTeacherView(),
    const RessourcesTeacherView(),
    const ProfileView(),
  ];

  // Getters pour les données de l'enseignant
  String get userName {
    final user = _userService.user;
    if (user == null) return 'Enseignant';
    
    if (enseignant.value != null) {
      final nom = enseignant.value!.nom;
      final prenom = enseignant.value!.prenom;
      return 'Bienvenu M. ${prenom.isNotEmpty ? prenom : nom}';
    }
    
    return 'Bienvenu ${user.name ?? "Enseignant"}';
  }

  String get specialiteNiveau {
    if (enseignant.value != null) {
      final specialite = enseignant.value!.specialite ?? 'Enseignant';
      return '$specialite _ Enseignant';
    }
    return 'En chargement...';
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> loadEnseignantData() async {
    try {
      isLoading.value = true;
      final userId = _userService.userId;
      
      if (userId == null) {
        print('[DashboardTeacher] userId est null');
        return;
      }
      
      print('[DashboardTeacher] Chargement des donnees enseignant ID: $userId');
      final data = await _enseignantRepository.getById(userId);
      enseignant.value = data;
      print('[DashboardTeacher] Donnees chargees - ${data.nom} ${data.prenom}');
    } catch (e) {
      print('[DashboardTeacher] Erreur chargement: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données enseignant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0;
    loadEnseignantData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
