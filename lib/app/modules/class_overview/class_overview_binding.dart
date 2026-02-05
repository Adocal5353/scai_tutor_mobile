import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/apprenant_provider.dart';

import 'class_overview_controller.dart';

class ClassOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClasseProvider>(
      () => ClasseProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<ApprenantProvider>(
      () => ApprenantProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<ClassOverviewController>(
      () => ClassOverviewController(),
    );
  }
}
