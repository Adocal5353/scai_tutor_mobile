import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';
import 'package:scai_tutor_mobile/app/data/repositories/invitation_repository.dart';
import 'package:scai_tutor_mobile/app/data/repositories/apprenant_repository.dart';

import 'add_child_controller.dart';

class AddChildBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvitationRepository>(
      () => InvitationRepository(),
    );
    Get.lazyPut<ApprenantRepository>(
      () => ApprenantRepository(),
    );
    Get.lazyPut<AddChildController>(
      () => AddChildController(),
    );
  }
}
