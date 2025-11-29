import 'package:get/get.dart';

class HouseholdController extends GetxController {
  final children = <Map<String, dynamic>>[].obs;
  final selectedChildIndex = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    _loadChildren();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _loadChildren() {
    children.value = [
      {
        'name': 'Juliette AFANVI',
        'status': 'Récemment inscrite',
        'avatar': 'assets/icons/justine.png',
        'isRegistered': false,
      },
      {
        'name': 'Joseph AFANVI',
        'status': 'Inscrit et à jour',
        'avatar': 'assets/icons/justin.png',
        'isRegistered': true,
        'recentScore': '13/20',
        'hasHomework': true,
      },
    ];
  }

  void goBack() {
    Get.back();
  }

  void addChild() {
    Get.snackbar(
      'Ajouter un enfant',
      'Fonctionnalité à implémenter',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleChild(int index) {
    if (selectedChildIndex.value == index) {
      selectedChildIndex.value = null;
    } else {
      selectedChildIndex.value = index;
    }
  }
}
