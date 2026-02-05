import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/evaluation_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/evaluation_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';
import 'package:scai_tutor_mobile/app/modules/ressources_teacher/ressources_teacher_controller.dart';
import 'package:intl/intl.dart';

class AssignHomeworkController extends GetxController {
  final EvaluationProvider _evaluationProvider = EvaluationProvider(Get.find<ApiProvider>());
  final UserService _userService = Get.find<UserService>();

  final RxList<EvaluationModel> evaluations = <EvaluationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  List<Map<String, dynamic>> get homeworks => evaluations
    .map((eval) => {
      'titre': eval.titre,
      'date': eval.dateCreation != null 
        ? DateFormat('dd / MM / yyyy').format(DateTime.parse(eval.dateCreation!))
        : 'Date inconnue',
      'evaluation': eval,
    }).toList();

  @override
  void onInit() {
    super.onInit();
    fetchEvaluations();
  }

  Future<void> fetchEvaluations() async {
    try {
      isLoading.value = true;
      error.value = '';

      final userId = _userService.user?.id;
      if (userId == null) {
        error.value = 'Utilisateur non connecte';
        return;
      }

      final response = await _evaluationProvider.getAll(
        params: {'id_enseignant': userId}
      );

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        evaluations.value = data
          .map((json) => EvaluationModel.fromJson(json as Map<String, dynamic>))
          .toList();
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les evaluations',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goBack() {
    Get.back();
  }

  void assignPracticeQuiz() async {
    final result = await Get.toNamed(Routes.CREATE_QUIZ);
    if (result == true) {
      // Rafraîchir la liste des evaluations après création
      fetchEvaluations();
    }
  }

  void uploadDocument() async {
    final result = await Get.toNamed(Routes.UPLOAD_DOCUMENT);
    if (result == true) {
      // Document créé avec succès - rafraîchir la page des ressources si elle est active
      if (Get.isRegistered<RessourcesTeacherController>()) {
        Get.find<RessourcesTeacherController>().fetchDocuments();
      }
      
      Get.snackbar(
        'Succès',
        'Document ajouté avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
      );
    }
  }

  void openHomework(int index) {
    final evaluation = homeworks[index]['evaluation'] as EvaluationModel;
    
    // Navigation vers les détails/soumissions de l'évaluation
    Get.toNamed(
      '/submissions',
      arguments: {
        'evaluationId': evaluation.id,
        'evaluationTitle': evaluation.titre,
        'idMatiere': evaluation.idMatiere,
      },
    );
  }
}
