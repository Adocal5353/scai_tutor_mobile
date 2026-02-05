import 'package:get/get.dart';

class ProOfferController extends GetxController {
  final RxList<Map<String, dynamic>> advantages = <Map<String, dynamic>>[
    {
      'text': 'Des essais infinis',
      'icon': 'favorite',
      'iconColor': 0xFF2196F3,
    },
    {
      'text': 'Pratique dans la vie réelle',
      'icon': 'favorite',
      'iconColor': 0xFF66BB6A,
    },
    {
      'text': 'Un model sans pubs',
      'icon': 'campaign',
      'iconColor': 0xFFBA68C8,
      'isNoAds': true,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void close() {
    Get.back();
  }

  void startFreeTrial() {
    Get.snackbar(
      'Essai gratuit',
      'Fonctionnalité à implémenter : Démarrer l\'essai gratuit',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
