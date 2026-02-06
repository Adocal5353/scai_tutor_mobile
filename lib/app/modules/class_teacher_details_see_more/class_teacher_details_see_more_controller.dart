import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';
import 'package:scai_tutor_mobile/app/modules/class_teacher_details/class_teacher_details_controller.dart';

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
    
    try {
      final detailsController = Get.find<ClassTeacherDetailsController>();
      
      print('[SeeMore] Navigation vers invitation:');
      print('  - className: ${detailsController.className.value}');
      print('  - classLevel: ${detailsController.classLevel.value}');
      print('  - classeId: "${detailsController.classeId.value}"');
      
      Get.toNamed(
        Routes.CLASS_INVITATION_FROM_TEACHER,
        arguments: {
          'className': detailsController.className.value,
          'classLevel': detailsController.classLevel.value,
          'classeId': detailsController.classeId.value,
        },
      );
    } catch (e) {
      print('[SeeMore] Erreur navigation invitation: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'accéder à la page d\'invitation',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void viewStudents() {
    Get.back();
    // TODO: Cette fonctionnalité nécessite l'endpoint GET /classes/{id}/apprenants
    Get.snackbar(
      'Information',
      'Liste des élèves à venir (endpoint API manquant)',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void leaveClass() {
    Get.back();
    // TODO: Cette fonctionnalité nécessite l'endpoint DELETE /classes/{id}/leave
    Get.snackbar(
      'Information',
      'Quitter la classe à venir (endpoint API manquant)',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
