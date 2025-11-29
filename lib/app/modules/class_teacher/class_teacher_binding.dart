import 'package:get/get.dart';

import 'class_teacher_controller.dart';

class ClassTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassTeacherController>(
      () => ClassTeacherController(),
    );
  }
}
