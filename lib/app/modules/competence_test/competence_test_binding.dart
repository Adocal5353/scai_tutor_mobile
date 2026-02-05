import 'package:get/get.dart';
import 'competence_test_controller.dart';

class CompetenceTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompetenceTestController>(() => CompetenceTestController());
  }
}
