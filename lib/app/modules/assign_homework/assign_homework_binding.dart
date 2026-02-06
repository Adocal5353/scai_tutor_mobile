import 'package:get/get.dart';

import 'assign_homework_controller.dart';

class AssignHomeworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignHomeworkController>(
      () => AssignHomeworkController(),
    );
  }
}
