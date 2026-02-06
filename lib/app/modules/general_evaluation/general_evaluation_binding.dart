import 'package:get/get.dart';

import 'general_evaluation_controller.dart';

class GeneralEvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GeneralEvaluationController>(
      () => GeneralEvaluationController(),
    );
  }
}
