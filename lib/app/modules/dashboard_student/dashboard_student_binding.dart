import 'package:get/get.dart';

import 'dashboard_student_controller.dart';
import 'package:scai_tutor_mobile/app/modules/profile/profile_controller.dart';

class DashboardStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardStudentController>(
      () => DashboardStudentController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
