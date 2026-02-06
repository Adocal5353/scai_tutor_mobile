import 'package:get/get.dart';
import 'learning_subject_detail_controller.dart';

class LearningSubjectDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LearningSubjectDetailController>(
      () => LearningSubjectDetailController(),
    );
  }
}
