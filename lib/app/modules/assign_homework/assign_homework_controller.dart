import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/evaluation_model.dart';
import 'package:scai_tutor_mobile/app/data/models/quiz_model.dart';
import 'package:scai_tutor_mobile/app/data/models/classe.dart';
import 'package:scai_tutor_mobile/app/data/providers/evaluation_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/quiz_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';
import 'package:scai_tutor_mobile/app/modules/ressources_teacher/ressources_teacher_controller.dart';
import 'package:intl/intl.dart';

class AssignHomeworkController extends GetxController {
  final EvaluationProvider _evaluationProvider = EvaluationProvider(Get.find<ApiProvider>());
  final QuizProvider _quizProvider = QuizProvider(Get.find<ApiProvider>());
  final ClasseProvider _classeProvider = ClasseProvider(Get.find<ApiProvider>());
  final UserService _userService = Get.find<UserService>();

  final RxList<EvaluationModel> evaluations = <EvaluationModel>[].obs;
  final RxList<QuizModel> quizzes = <QuizModel>[].obs;
  final RxList<Classe> classes = <Classe>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  List<Map<String, dynamic>> get homeworks {
    // Combiner les évaluations et les quiz
    final List<Map<String, dynamic>> combined = [];
    
    // Ajouter les évaluations
    combined.addAll(evaluations.map((eval) => {
      'titre': eval.titre,
      'date': eval.dateCreation != null 
        ? DateFormat('dd / MM / yyyy').format(DateTime.parse(eval.dateCreation!))
        : 'Date inconnue',
      'type': 'evaluation',
      'evaluation': eval,
    }).toList());
    
    // Ajouter les quiz
    combined.addAll(quizzes.map((quiz) => {
      'titre': quiz.titre,
      'date': quiz.dateCreation != null 
        ? DateFormat('dd / MM / yyyy').format(quiz.dateCreation!)
        : 'Date inconnue',
      'type': 'quiz',
      'quiz': quiz,
    }).toList());
    
    return combined;
  }

  @override
  void onInit() {
    super.onInit();
    fetchEvaluations();
    fetchQuizzes();
    fetchClasses();
  }

  Future<void> fetchQuizzes() async {
    try {
      final userId = _userService.user?.id;
      if (userId == null) return;

      final response = await _quizProvider.getAll(
        params: {'id_enseignant': userId}
      );

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? response.data['quizzes'] ?? []);
        
        quizzes.value = data
          .map((json) => QuizModel.fromJson(json as Map<String, dynamic>))
          .toList();

        print('[AssignHomework] Loaded ${quizzes.length} quizzes');
      }
    } catch (e) {
      print('[AssignHomework] Error loading quizzes: $e');
    }
  }

  Future<void> fetchClasses() async {
    try {
      final userId = _userService.user?.id;
      if (userId == null) return;

      final response = await _classeProvider.getAll(
        params: {'id_enseignant': userId}
      );

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        classes.value = data
          .map((json) => Classe.fromJson(json as Map<String, dynamic>))
          .toList();

        print('[AssignHomework] Loaded ${classes.length} classes');
      }
    } catch (e) {
      print('[AssignHomework] Error loading classes: $e');
    }
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

  Future<void> assignQuizToClass(QuizModel quiz) async {
    if (classes.isEmpty) {
      Get.snackbar(
        'Information',
        'Aucune classe disponible. Veuillez d\'abord créer une classe.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Dialogue pour sélectionner une classe
    final selectedClasse = await Get.dialog<Classe>(
      AlertDialog(
        title: const Text('Assigner à une classe'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classe = classes[index];
              return ListTile(
                title: Text(classe.subject),
                subtitle: Text(classe.level),
                onTap: () => Get.back(result: classe),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );

    if (selectedClasse == null || quiz.id == null) return;

    try {
      isLoading.value = true;

      await _quizProvider.assignToClasse(quiz.id!, selectedClasse.id);

      Get.snackbar(
        'Succès',
        'Quiz assigné à la classe ${selectedClasse.subject}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
      );

      fetchQuizzes();
    } catch (e) {
      print('[AssignHomework] Error assigning quiz: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'assigner le quiz',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void openHomework(int index) {
    final homework = homeworks[index];
    final type = homework['type'];

    if (type == 'quiz' && homework['quiz'] != null) {
      // Assigner le quiz à une classe
      assignQuizToClass(homework['quiz']);
    } else {
      // Logique existante pour les évaluations
      // TODO: Implémenter l'ouverture d'évaluation si nécessaire
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
}
