import 'package:get/get.dart';

import 'class_overview_controller.dart';

class ClassOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassOverviewController>(
      () => ClassOverviewController(),
    );
  }
}
