import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/modules/profile/profile_controller.dart';
import 'package:scai_tutor_mobile/app/modules/Household/household_controller.dart';

import 'parent_guardian_controller.dart';

class ParentGuardianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ParentGuardianController>(
      () => ParentGuardianController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<HouseholdController>(
      () => HouseholdController(),
    );
  }
}
