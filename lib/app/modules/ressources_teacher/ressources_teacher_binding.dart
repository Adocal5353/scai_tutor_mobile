import 'package:get/get.dart';

import 'ressources_teacher_controller.dart';

class RessourcesTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RessourcesTeacherController>(
      () => RessourcesTeacherController(),
    );
  }
}
