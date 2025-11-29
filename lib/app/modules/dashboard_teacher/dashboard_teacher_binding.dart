import 'package:get/get.dart';

import 'dashboard_teacher_controller.dart';
import 'package:scai_tutor_mobile/app/modules/class_teacher/class_teacher_controller.dart';
import 'package:scai_tutor_mobile/app/modules/ressources_teacher/ressources_teacher_controller.dart';
import 'package:scai_tutor_mobile/app/modules/profile/profile_controller.dart';

class DashboardTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardTeacherController>(
      () => DashboardTeacherController(),
    );
    Get.lazyPut<ClassTeacherController>(
      () => ClassTeacherController(),
    );
    Get.lazyPut<RessourcesTeacherController>(
      () => RessourcesTeacherController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
