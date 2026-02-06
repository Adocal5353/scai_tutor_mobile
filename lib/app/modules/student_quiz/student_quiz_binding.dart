import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/quiz_provider.dart';

import 'student_quiz_controller.dart';

class StudentQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuizProvider>(
      () => QuizProvider(Get.find<ApiProvider>()),
    );
    Get.lazyPut<StudentQuizController>(
      () => StudentQuizController(),
    );
  }
}
