import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class ParentGuardianController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goToFoyer() {
    Get.toNamed(Routes.HOUSEHOLD);
  }

  void goToScAIBot() {
    Get.toNamed(Routes.SCS_A_I_BOT);
  }
}
