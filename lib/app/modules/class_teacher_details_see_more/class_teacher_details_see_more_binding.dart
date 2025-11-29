import 'package:get/get.dart';

import 'class_teacher_details_see_more_controller.dart';

class ClassTeacherDetailsSeeMoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassTeacherDetailsSeeMoreController>(
      () => ClassTeacherDetailsSeeMoreController(),
    );
  }
}
