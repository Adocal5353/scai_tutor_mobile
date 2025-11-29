import 'package:get/get.dart';

import 'class_chat_controller.dart';

class ClassChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClassChatController>(
      () => ClassChatController(),
    );
  }
}
