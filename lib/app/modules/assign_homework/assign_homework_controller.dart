import 'package:get/get.dart';

class AssignHomeworkController extends GetxController {
  // Liste des devoirs
  final homeworks = <Map<String, dynamic>>[
    {
      'titre': 'Quiz 1',
      'date': '15 / 05 / 2025',
    },
    {
      'titre': 'Quiz 2',
      'date': '20 / 05 / 2025',
    },
    {
      'titre': 'Exercice pratique 1',
      'date': '20 / 05 / 2025',
    },
    {
      'titre': 'Quiz 3',
      'date': '25 / 05 / 2025',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goBack() {
    Get.back();
  }

  void assignPracticeQuiz() {
    Get.snackbar(
      'Info',
      'Donner des quiz pratiques',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void uploadDocument() {
    Get.snackbar(
      'Info',
      'Charger un document à vendre',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void openHomework(int index) {
    Get.snackbar(
      'Info',
      'Ouvrir ${homeworks[index]['titre']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
