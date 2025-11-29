import 'package:get/get.dart';

class ClassTeacherDetailsSeeMoreController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void inviteStudent() {
    Get.back();
    Get.snackbar(
      'Info',
      'Inviter un élève',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewStudents() {
    Get.back();
    Get.snackbar(
      'Info',
      'Mes élèves',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void leaveClass() {
    Get.back();
    Get.snackbar(
      'Info',
      'Quitter la classe',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
