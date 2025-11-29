import 'package:get/get.dart';

import 'parent_guardian_controller.dart';

class ParentGuardianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentGuardianController>(
      () => ParentGuardianController(),
    );
  }
}
