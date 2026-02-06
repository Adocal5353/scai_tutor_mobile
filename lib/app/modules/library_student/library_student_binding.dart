import 'package:get/get.dart';
import 'library_student_controller.dart';

class LibraryStudentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LibraryStudentController>(
      () => LibraryStudentController(),
    );
  }
}
