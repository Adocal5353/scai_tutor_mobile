import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/document_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';

import 'upload_video_controller.dart';

class UploadVideoBinding extends Bindings {
  @override
  void dependencies() {
    // Initialiser les providers en premier avec Get.put pour garantir leur disponibilité
    if (!Get.isRegistered<DocumentProvider>()) {
      Get.put<DocumentProvider>(
        DocumentProvider(Get.find<ApiProvider>()),
      );
    }
    if (!Get.isRegistered<ClasseProvider>()) {
      Get.put<ClasseProvider>(
        ClasseProvider(Get.find<ApiProvider>()),
      );
    }
    // Puis initialiser le controller
    Get.lazyPut<UploadVideoController>(
      () => UploadVideoController(),
    );
  }
}
