import 'package:get/get.dart';
import 'subject_evaluation_controller.dart';

class SubjectEvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectEvaluationController>(
      () => SubjectEvaluationController(),
    );
  }
}
