import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';
import 'package:scai_tutor_mobile/app/modules/class_teacher_details_see_more/class_teacher_details_see_more_view.dart';
import 'package:scai_tutor_mobile/app/data/models/evaluation_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/evaluation_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/repositories/classe_repository.dart';

class ClassTeacherDetailsController extends GetxController {
  final EvaluationProvider _evaluationProvider = EvaluationProvider(Get.find<ApiProvider>());
  final ClasseRepository _classeRepository = ClasseRepository();

  final className = ''.obs;
  final classLevel = ''.obs;
  final classeId = ''.obs;
  final searchQuery = ''.obs;

  final RxList<EvaluationModel> allEvaluations = <EvaluationModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isSearching = false.obs;

  List<EvaluationModel> get filteredEvaluations {
    if (searchQuery.value.isEmpty) {
      return allEvaluations;
    }
    
    final query = searchQuery.value.toLowerCase();
    return allEvaluations.where((e) {
      final titre = e.titre.toLowerCase();
      final chapitres = (e.chapitresConcernes ?? '').toLowerCase();
      return titre.contains(query) || chapitres.contains(query);
    }).toList();
  }

  List<EvaluationModel> get newExercises => filteredEvaluations
    .where((e) => e.dateCreation != null && DateTime.parse(e.dateCreation!).isAfter(DateTime.now().subtract(const Duration(days: 7))))
    .toList();

  List<EvaluationModel> get sentExercises => filteredEvaluations
    .where((e) => e.dateCreation == null || !DateTime.parse(e.dateCreation!).isAfter(DateTime.now().subtract(const Duration(days: 7))))
    .toList();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    print('[ClassDetails] Arguments recus: $args');
    if (args != null) {
      className.value = args['className'] ?? 'Classe';
      classLevel.value = args['classLevel'] ?? '';
      classeId.value = args['classeId'] ?? '';
      print('[ClassDetails] Classe initialisee:');
      print('  - className: ${className.value}');
      print('  - classLevel: ${classLevel.value}');
      print('  - classeId: "${classeId.value}"');
      if (classeId.value.isNotEmpty) {
        fetchEvaluations();
      } else {
        print('[ClassDetails] ATTENTION: classeId est vide!');
      }
    }
  }

  Future<void> fetchEvaluations() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _evaluationProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        allEvaluations.value = data
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

  void showMoreOptions() {
    Get.bottomSheet(
      const ClassTeacherDetailsSeeMoreView(),
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
    );
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }
  
  void clearSearch() {
    searchQuery.value = '';
  }
  
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      clearSearch();
    }
  }

  void onSearchTap() {
    toggleSearch();
  }

  void openExercise(EvaluationModel evaluation) {
    // Navigation vers les détails de l'évaluation avec soumissions
    Get.toNamed(
      Routes.SUBMISSIONS,
      arguments: {
        'evaluationId': evaluation.id,
        'evaluationTitle': evaluation.titre,
        'idMatiere': evaluation.idMatiere,
        'classeId': classeId.value,
      },
    );
  }

  /// Supprimer la classe
  Future<void> deleteClass() async {
    print('[ClassDetails] Tentative suppression classe:');
    print('  - classeId actuel: "${classeId.value}"');
    
    if (classeId.value.isEmpty) {
      print('[ClassDetails] ERREUR: classeId est vide!');
      Get.snackbar(
        'Erreur',
        'ID de classe manquant',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      Get.back();
      isLoading.value = true;

      print('[ClassDetails] Suppression de la classe: ${classeId.value}');
      await _classeRepository.delete(classeId.value);
      print('[ClassDetails] Classe supprimee avec succes');

      Get.back();
      Get.snackbar(
        'Succès',
        'Classe supprimée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    } catch (e) {
      print('[ClassDetails] Erreur suppression: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de supprimer la classe: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
