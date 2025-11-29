import 'package:get/get.dart';

class ClassInvitationFromTeacherController extends GetxController {
  // Informations de la classe
  final className = 'Classe de Physiques'.obs;
  final classLevel = '4ème'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goBack() {
    Get.back();
  }

  void inviteStudents() {
    Get.snackbar(
      'Info',
      'Inviter des élèves',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showMoreOptions() {
    Get.snackbar(
      'Info',
      'Options de la classe',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
