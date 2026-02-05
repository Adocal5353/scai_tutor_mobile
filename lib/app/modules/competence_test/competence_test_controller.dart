import 'package:get/get.dart';

class CompetenceTestController extends GetxController {
  final RxString subjectName = ''.obs;
  final RxInt trimesterNumber = 1.obs;
  
  @override
  void onInit() {
    super.onInit();
    // Récupérer les arguments de navigation
    if (Get.arguments != null) {
      subjectName.value = Get.arguments['subjectName'] ?? '';
      trimesterNumber.value = Get.arguments['trimesterNumber'] ?? 1;
    }
  }
  
  void closeTest() {
    Get.back();
  }
  
  void startTest() {
    // TODO: Naviguer vers la page de test/quiz
    Get.snackbar(
      'Test du trimestre ${trimesterNumber.value}',
      'Démarrage du test pour ${subjectName.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
    // Fermer la page de proposition
    Get.back();
  }
  
  String getTrimesterLabel() {
    switch (trimesterNumber.value) {
      case 1:
        return '1er trimestre';
      case 2:
        return '2ème trimestre';
      case 3:
        return '3ème trimestre';
      default:
        return '${trimesterNumber.value}ème trimestre';
    }
  }
}
