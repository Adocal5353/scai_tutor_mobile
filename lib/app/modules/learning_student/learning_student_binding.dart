import 'package:get/get.dart';
import 'learning_student_controller.dart';

class LearningStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LearningStudentController>(
      () => LearningStudentController(),
    );
  }
}
