import 'package:get/get.dart';
import 'pro_offer_controller.dart';

class ProOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProOfferController>(
      () => ProOfferController(),
    );
  }
}
