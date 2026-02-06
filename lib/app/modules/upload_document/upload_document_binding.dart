import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/document_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';

import 'upload_document_controller.dart';

class UploadDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentProvider>(
      () => DocumentProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<ClasseProvider>(
      () => ClasseProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<UploadDocumentController>(
      () => UploadDocumentController(),
    );
  }
}
