import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/resultat_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/resultat_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';

class SubmissionsController extends GetxController {
  final ResultatProvider _resultatProvider = ResultatProvider(Get.find<ApiProvider>());

  final RxList<Map<String, dynamic>> submissions = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSubmissions();
  }

  Future<void> fetchSubmissions() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _resultatProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        final resultats = data
          .map((json) => ResultatModel.fromJson(json as Map<String, dynamic>))
          .toList();

        final groupedByClass = <String, List<Map<String, dynamic>>>{};
        
        for (var resultat in resultats) {
          final niveau = 'Niveau inconnu';
          if (!groupedByClass.containsKey(niveau)) {
            groupedByClass[niveau] = [];
          }
          
          groupedByClass[niveau]!.add({
            'titre': 'Evaluation',
            'temps': _getRelativeTime(resultat.dateSoumission != null 
              ? DateTime.tryParse(resultat.dateSoumission!)
              : null),
            'badge': '1',
            'resultat': resultat,
          });
        }

        submissions.value = groupedByClass.entries.map((entry) => {
          'niveau': entry.key,
          'devoirs': entry.value,
        }).toList();
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les soumissions',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _getRelativeTime(DateTime? date) {
    if (date == null) return 'Date inconnue';
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inMinutes < 60) {
      return 'Soumis il y a ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Soumis il y a ${difference.inHours}h';
    } else {
      return 'Soumis il y a ${difference.inDays}j';
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
