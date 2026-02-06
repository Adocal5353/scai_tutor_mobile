import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/evaluation_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/matiere_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/quiz_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/ai_provider.dart';

import 'create_quiz_controller.dart';

class CreateQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EvaluationProvider>(
      () => EvaluationProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<MatiereProvider>(
      () => MatiereProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<QuizProvider>(
      () => QuizProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<AiProvider>(
      () => AiProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<CreateQuizController>(
      () => CreateQuizController(),
    );
  }
}
