import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/evaluation_model.dart';
import '../../data/models/resultat_model.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../../data/repositories/resultat_repository.dart';
import '../../data/services/user_service.dart';

class GeneralEvaluationController extends GetxController {
  final EvaluationRepository _evaluationRepository = EvaluationRepository();
  final ResultatRepository _resultatRepository = ResultatRepository();
  final UserService _userService = Get.find<UserService>();

  // Observable lists for backend data
  final RxList<EvaluationModel> evaluations = <EvaluationModel>[].obs;
  final RxList<ResultatModel> resultats = <ResultatModel>[].obs;
  
  // Loading state
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load evaluation data from backend
  Future<void> loadData() async {
    try {
      isLoading.value = true;
      error.value = '';

      print('[GeneralEvaluationController] Chargement des données...');

      // Fetch evaluations and results from backend
      await Future.wait([
        _fetchEvaluations(),
        _fetchResultats(),
      ]);

      print('[GeneralEvaluationController] ${evaluations.length} évaluations et ${resultats.length} résultats chargés');
    } catch (e) {
      error.value = e.toString();
      print('[GeneralEvaluationController] Erreur: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch evaluations from backend
  Future<void> _fetchEvaluations() async {
    try {
      evaluations.value = await _evaluationRepository.getAll();
    } catch (e) {
      print('[GeneralEvaluationController] Erreur chargement évaluations: $e');
    }
  }

  /// Fetch results from backend
  Future<void> _fetchResultats() async {
    try {
      resultats.value = await _resultatRepository.getAll();
    } catch (e) {
      print('[GeneralEvaluationController] Erreur chargement résultats: $e');
    }
  }

  /// Start general evaluation (all 3 subjects)
  Future<void> startGeneralEvaluation() async {
    print('[GeneralEvaluationController] Démarrage évaluation générale...');
    
    try {
      final userId = _userService.userId;
      if (userId == null) {
        Get.snackbar(
          'Erreur',
          'Vous devez être connecté',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        );
        return;
      }

      isLoading.value = true;

      // Look for general evaluation in the backend data
      EvaluationModel? generalEvaluation;
      if (evaluations.isNotEmpty) {
        generalEvaluation = evaluations.firstWhere(
          (e) => e.titre.toLowerCase().contains('générale') || 
                 e.titre.toLowerCase().contains('general'),
          orElse: () => evaluations.first,
        );
      }

      if (generalEvaluation?.id != null) {
        // Start evaluation via API
        await _resultatRepository.demarrerEvaluation(
          idApprenant: userId,
          idEvaluation: generalEvaluation!.id!,
        );

        Get.snackbar(
          'Succès',
          'Évaluation générale démarrée',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
        );

        // TODO: Navigate to general evaluation test screen
        // Get.toNamed('/general-evaluation-test', arguments: {'evaluation': generalEvaluation});
      } else {
        Get.snackbar(
          'Info',
          'Démarrage de l\'évaluation générale',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1565C0).withOpacity(0.2),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('[GeneralEvaluationController] Erreur: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de démarrer l\'évaluation',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
