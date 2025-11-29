import 'package:get/get.dart';

import 'household_controller.dart';

class HouseholdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HouseholdController>(
      () => HouseholdController(),
    );
  }
}
