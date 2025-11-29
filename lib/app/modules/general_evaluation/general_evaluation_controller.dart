import 'package:get/get.dart';

class GeneralEvaluationController extends GetxController {
  void goBack() {
    Get.back();
  }

  void startEvaluation() {
    Get.snackbar(
      'Évaluation',
      'Fonctionnalité à implémenter',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
