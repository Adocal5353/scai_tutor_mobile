import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/classe_model.dart';
import 'package:scai_tutor_mobile/app/data/models/apprenant_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/apprenant_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';

class ClassOverviewController extends GetxController {
  final ClasseProvider _classeProvider = Get.find<ClasseProvider>();
  final ApprenantProvider _apprenantProvider = Get.find<ApprenantProvider>();
  final UserService _userService = Get.find<UserService>();

  final RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClassPanorama();
  }

  Future<void> fetchClassPanorama() async {
    try {
      isLoading.value = true;
      error.value = '';

      final userId = _userService.user?.id;
      if (userId == null) {
        error.value = 'Utilisateur non connecté';
        return;
      }

      print('[ClassOverview] Fetching classes for teacher: $userId');

      // Récupérer toutes les classes de l'enseignant
      final classesResponse = await _classeProvider.getAll(
        params: {'id_enseignant': userId},
      );

      if (classesResponse.data == null) {
        print('[ClassOverview] No classes data received');
        classes.value = [];
        return;
      }

      final List<dynamic> classesData = classesResponse.data is List
          ? classesResponse.data
          : (classesResponse.data['data'] ?? []);

      final List<ClasseModel> classesList = classesData
          .map((json) => ClasseModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print('[ClassOverview] Loaded ${classesList.length} classes');

      // Récupérer tous les apprenants pour calculer les statistiques
      final apprenantsResponse = await _apprenantProvider.getAll();
      
      final List<dynamic> apprenantsData = apprenantsResponse.data is List
          ? apprenantsResponse.data
          : (apprenantsResponse.data['data'] ?? []);

      final List<ApprenantModel> allApprenants = apprenantsData
          .map((json) => ApprenantModel.fromJson(json as Map<String, dynamic>))
          .toList();

      print('[ClassOverview] Loaded ${allApprenants.length} total apprenants');

      // Construire les statistiques par classe
      List<Map<String, dynamic>> classStats = [];

      for (var classe in classesList) {
        // Filtrer les apprenants de cette classe
        final classApprenants = allApprenants
            .where((a) => a.idClasse == classe.id)
            .toList();

        final int nombreEleves = classApprenants.length;

        // Pour l'instant, utiliser des valeurs simulées pour l'évolution
        // TODO: Calculer les vraies statistiques basées sur les résultats des évaluations
        final double faibles = nombreEleves * 0.2; // 20% faibles
        final double moyens = nombreEleves * 0.5;  // 50% moyens
        final double evolues = nombreEleves * 0.3; // 30% évolués

        classStats.add({
          'niveau': classe.niveauScolaire ?? classe.nomClasse,
          'nombreEleves': nombreEleves,
          'evolution': {
            'faibles': faibles,
            'moyens': moyens,
            'evolues': evolues,
          },
        });
      }

      classes.value = classStats;
      print('[ClassOverview] Built stats for ${classStats.length} classes');
      
    } catch (e) {
      error.value = e.toString();
      print('[ClassOverview] Error fetching panorama: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger le panorama des classes',
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
}
