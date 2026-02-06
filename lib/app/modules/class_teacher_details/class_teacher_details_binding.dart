import 'package:get/get.dart';

import 'class_teacher_details_controller.dart';

class ClassTeacherDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassTeacherDetailsController>(
      () => ClassTeacherDetailsController(),
    );
  }
}
