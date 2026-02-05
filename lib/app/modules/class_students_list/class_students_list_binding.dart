import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/apprenant_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';

import 'class_students_list_controller.dart';

class ClassStudentsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApprenantProvider>(
      () => ApprenantProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<ClassStudentsListController>(
      () => ClassStudentsListController(),
    );
  }
}
