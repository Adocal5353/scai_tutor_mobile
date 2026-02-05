import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/evaluation_repository.dart';
import '../../data/repositories/resultat_repository.dart';
import '../../data/models/evaluation_model.dart';
import '../../data/models/resultat_model.dart';
import '../../data/models/matiere_model.dart';
import '../../data/providers/matiere_provider.dart';
import '../../data/providers/api_provider.dart';
import '../../data/services/user_service.dart';

class SubjectEvaluationController extends GetxController {
  final EvaluationRepository _evaluationRepository = EvaluationRepository();
  final ResultatRepository _resultatRepository = ResultatRepository();
  final MatiereProvider _matiereProvider = MatiereProvider(Get.find<ApiProvider>());
  final UserService _userService = Get.find<UserService>();

  final RxBool isLoading = false.obs;
  final RxString subject = ''.obs;
  final RxString evaluationPeriod = ''.obs;
  final RxDouble progressValue = 0.0.obs;
  final RxString progressLabel = '0%'.obs;
  final RxList<Map<String, dynamic>> chapterResults = <Map<String, dynamic>>[].obs;

  List<EvaluationModel> evaluations = [];
  List<ResultatModel> resultats = [];
  List<MatiereModel> matieres = [];
  String? matiereId;

  @override
  void onInit() {
    super.onInit();
    // Récupérer la matière depuis les arguments de navigation
    final args = Get.arguments as Map<String, dynamic>?;
    subject.value = args?['subject'] ?? 'Inconnu';
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadMatieres(),
        _fetchEvaluations(),
        _fetchResultats(),
      ]);
      _calculateProgress();
      _buildChapterResults();
      _determineEvaluationPeriod();
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadMatieres() async {
    try {
      final response = await _matiereProvider.getAll();
      
      if (response.data != null) {
        var dataSource = response.data;
        
        // Vérifier si les données sont dans une clé 'data'
        if (dataSource is Map && dataSource.containsKey('data')) {
          dataSource = dataSource['data'];
        }
        if (dataSource is List) {
          matieres = dataSource.map((json) => MatiereModel.fromJson(json)).toList();
          
          // Trouver l'ID de la matière correspondante
          final matiere = matieres.firstWhere(
            (m) => m.nomMatiere.toLowerCase().contains(subject.value.toLowerCase()),
            orElse: () => MatiereModel(nomMatiere: subject.value),
          );
          matiereId = matiere.id;
          print('[SubjectEvaluation] Matière trouvée: ${matiere.nomMatiere}, ID: $matiereId');
        }
      }
    } catch (e) {
      print('[SubjectEvaluation] Erreur chargement matières: $e');
    }
  }

  Future<void> _fetchEvaluations() async {
    try {
      final allEvals = await _evaluationRepository.getAll();
      
      // Filtrer par matière si on a trouvé l'ID
      if (matiereId != null) {
        evaluations = allEvals.where((e) => e.idMatiere == matiereId).toList();
      } else {
        // Fallback: filtrer par titre contenant le nom de la matière
        evaluations = allEvals.where((e) {
          final titre = e.titre.toLowerCase();
          return titre.contains(subject.value.toLowerCase());
        }).toList();
      }
      
      print('[SubjectEvaluation] ${evaluations.length} évaluations trouvées pour ${subject.value}');
    } catch (e) {
      print('[SubjectEvaluation] Erreur récupération évaluations: $e');
    }
  }

  Future<void> _fetchResultats() async {
    try {
      final userId = _userService.userId;
      if (userId == null) {
        print('[SubjectEvaluation] Utilisateur non connecté');
        return;
      }

      // Récupérer tous les résultats de l'apprenant
      final allResultats = await _resultatRepository.getAll(
        params: {'id_apprenant': userId}
      );
      
      // Filtrer pour ne garder que les résultats des évaluations de cette matière
      final evaluationIds = evaluations.map((e) => e.id).toSet();
      resultats = allResultats.where((r) => evaluationIds.contains(r.idEvaluation)).toList();
      
      print('[SubjectEvaluation] ${resultats.length} résultats trouvés sur ${allResultats.length} total');
    } catch (e) {
      print('[SubjectEvaluation] Erreur récupération résultats: $e');
    }
  }

  void _calculateProgress() {
    if (evaluations.isEmpty) {
      progressValue.value = 0.0;
      progressLabel.value = '0%';
      return;
    }

    final completedCount = resultats.length;
    final totalCount = evaluations.length;
    final percentage = (completedCount / totalCount * 100).round();

    progressValue.value = completedCount / totalCount;
    progressLabel.value = '$percentage%';
  }

  void _buildChapterResults() {
    chapterResults.clear();
    
    // Grouper les résultats par évaluation
    final Map<String, List<ResultatModel>> resultsByEvaluation = {};
    for (var resultat in resultats) {
      final evalId = resultat.idEvaluation ?? '';
      if (!resultsByEvaluation.containsKey(evalId)) {
        resultsByEvaluation[evalId] = [];
      }
      resultsByEvaluation[evalId]!.add(resultat);
    }
    
    // Créer les résultats par chapitre
    final Map<String, List<double>> scoresByChapter = {};
    
    for (var evaluation in evaluations) {
      final evalResults = resultsByEvaluation[evaluation.id] ?? [];
      if (evalResults.isEmpty) continue;
      
      // Parser les chapitres concernés (format: "Chapitre 1, Chapitre 2" ou similaire)
      final chapters = _parseChapters(evaluation.chapitresConcernes ?? evaluation.titre);
      
      for (var chapter in chapters) {
        if (!scoresByChapter.containsKey(chapter)) {
          scoresByChapter[chapter] = [];
        }
        // Ajouter les notes de cette évaluation pour ce chapitre
        scoresByChapter[chapter]!.addAll(
          evalResults.map((r) => r.note ?? 0.0).where((n) => n > 0)
        );
      }
    }
    
    // Construire les cartes de résultats
    scoresByChapter.forEach((chapter, scores) {
      if (scores.isEmpty) return;
      
      final avgScore = scores.reduce((a, b) => a + b) / scores.length;
      final tag = _getChapterTag(chapter);
      final hasLowScore = avgScore < 10.0;
      
      chapterResults.add({
        'chapterName': chapter,
        'score': avgScore.toStringAsFixed(2),
        'tag': tag,
        'hasLowScore': hasLowScore,
      });
    });
    
    print('[SubjectEvaluation] ${chapterResults.length} chapitres avec résultats');
  }
  
  List<String> _parseChapters(String chaptersString) {
    if (chaptersString.isEmpty) return ['Chapitre général'];
    
    // Séparer par virgules ou points-virgules
    final parts = chaptersString.split(RegExp(r'[,;]'));
    return parts.map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
  }
  
  String _getChapterTag(String chapterName) {
    final lowerName = chapterName.toLowerCase();
    if (lowerName.contains('algèbre') || lowerName.contains('algebre')) return 'Alg';
    if (lowerName.contains('géométrie') || lowerName.contains('geometrie')) return 'Géo';
    if (lowerName.contains('statistique')) return 'Stat';
    if (lowerName.contains('mécanique') || lowerName.contains('mecanique')) return 'Méca';
    if (lowerName.contains('électricité') || lowerName.contains('electricite')) return 'Élec';
    if (lowerName.contains('optique')) return 'Opt';
    if (lowerName.contains('chimie organique')) return 'Org';
    if (lowerName.contains('chimie minérale') || lowerName.contains('chimie minerale')) return 'Min';
    return 'Chap';
  }
  
  void _determineEvaluationPeriod() {
    if (evaluations.isEmpty) {
      evaluationPeriod.value = DateTime.now().year.toString();
      return;
    }
    
    // Extraire l'année de la première évaluation créée
    final firstEval = evaluations.first;
    if (firstEval.dateCreation != null) {
      try {
        final date = DateTime.parse(firstEval.dateCreation!);
        // Format: année scolaire (ex: 2024-2025)
        final year = date.year;
        final nextYear = year + 1;
        evaluationPeriod.value = '$year-$nextYear';
      } catch (e) {
        evaluationPeriod.value = DateTime.now().year.toString();
      }
    } else {
      evaluationPeriod.value = DateTime.now().year.toString();
    }
  }

  void startEvaluation() {
    Get.snackbar(
      'Évaluation',
      'Démarrage de l\'évaluation en ${subject.value}...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
    );
    // TODO: Navigation vers l'écran de test
  }
}
