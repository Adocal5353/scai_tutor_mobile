import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/quiz_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/ai_provider.dart';

import 'quiz_detail_controller.dart';

class QuizDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizProvider>(
      () => QuizProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<AiProvider>(
      () => AiProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<QuizDetailController>(
      () => QuizDetailController(),
    );
  }
}
