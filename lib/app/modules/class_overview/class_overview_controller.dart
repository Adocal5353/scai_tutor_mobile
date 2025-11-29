import 'package:get/get.dart';

class ClassOverviewController extends GetxController {
  // Données des classes par niveau
  final classes = <Map<String, dynamic>>[
    {
      'niveau': '3ème',
      'evolution': {
        'faibles': 60.0,
        'moyens': 90.0,
        'evolues': 120.0,
      }
    },
    {
      'niveau': '4ème',
      'evolution': {
        'faibles': 50.0,
        'moyens': 100.0,
        'evolues': 110.0,
      }
    },
    {
      'niveau': '5ème',
      'evolution': {
        'faibles': 70.0,
        'moyens': 85.0,
        'evolues': 100.0,
      }
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

  void goBack() {
    Get.back();
  }
}
