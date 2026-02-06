import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/Classe.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';

class ClassTeacherController extends GetxController {
  final ClasseProvider _classeProvider = ClasseProvider(Get.find<ApiProvider>());
  final UserService _userService = Get.find<UserService>();

  final RxList<Classe> classes = <Classe>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      isLoading.value = true;
      error.value = '';

      final userId = _userService.user?.id;
      if (userId == null) {
        error.value = 'Utilisateur non connecte';
        return;
      }

      final response = await _classeProvider.getAll(
        params: {'id_enseignant': userId}
      );

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        print('[ClassTeacher] Nombre de classes recues: ${data.length}');
        if (data.isNotEmpty) {
          print('[ClassTeacher] Premier element brut: ${data[0]}');
        }
        
        classes.value = data
          .map((json) => Classe.fromJson(json as Map<String, dynamic>))
          .toList();
        
        if (classes.isNotEmpty) {
          print('[ClassTeacher] Premiere classe parsee:');
          print('  - ID: "${classes[0].id}"');
          print('  - Sujet: ${classes[0].subject}');
          print('  - Niveau: ${classes[0].level}');
        }
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les classes',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goToClasseDetails(Classe classe) {
    print('[ClassTeacher] Navigation vers details:');
    print('  - className: ${classe.subject}');
    print('  - classLevel: ${classe.level}');
    print('  - classeId: "${classe.id}"');
    
    if (classe.id.isEmpty) {
      print('[ClassTeacher] ERREUR: classeId est vide!');
      Get.snackbar(
        'Erreur',
        'ID de classe manquant',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }
    
    Get.toNamed(
      '/class-teacher-details',
      arguments: {
        'className': classe.subject,
        'classLevel': classe.level,
        'classeId': classe.id,
      },
    );
  }
}
