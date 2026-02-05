import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/matiere_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/matiere_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';

class LearningStudentController extends GetxController {
  final MatiereProvider _matiereProvider = MatiereProvider(Get.find<ApiProvider>());

  final RxList<MatiereModel> allMatieres = <MatiereModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // Matières principales à afficher
  final List<Map<String, dynamic>> mainSubjects = [
    {
      'name': 'Mathématiques',
      'color': 0xFF2546D8,
      'textColor': 0xFFFFFFFF,
      'icon': 'calculate',
      'iconColor': 0xFFFFFFFF,
    },
    {
      'name': 'Physiques',
      'color': 0xFF2DB36F,
      'textColor': 0xFFFFFFFF,
      'icon': 'atom',
      'iconColor': 0xFFFFFFFF,
    },
    {
      'name': 'Chimie',
      'color': 0xFFD4D4D4,
      'textColor': 0xFF000000,
      'icon': 'science',
      'iconColor': 0xFF2DB36F,
    },
  ];

  @override
  void onInit() {
    super.onInit();
    fetchMatieres();
  }

  Future<void> fetchMatieres() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _matiereProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        allMatieres.value = data
          .map((json) => MatiereModel.fromJson(json as Map<String, dynamic>))
          .toList();
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les matières',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  void selectSubject(String subjectName) {
    // Navigate to subject detail page with the selected subject
    Get.toNamed(
      '/learning-subject-detail',
      arguments: {'subjectName': subjectName},
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
