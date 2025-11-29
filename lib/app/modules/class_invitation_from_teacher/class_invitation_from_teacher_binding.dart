import 'package:get/get.dart';

import 'class_invitation_from_teacher_controller.dart';

class ClassInvitationFromTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassInvitationFromTeacherController>(
      () => ClassInvitationFromTeacherController(),
    );
  }
}
