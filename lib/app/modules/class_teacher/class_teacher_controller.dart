import 'package:get/get.dart';

class ClassTeacherController extends GetxController {
  //TODO: Implement ClassTeacherController

  final count = 0.obs;
  
  // Liste des classes du professeur
  final RxList<Map<String, String>> classes = <Map<String, String>>[
    {'matiere': 'Maths', 'niveau': '6ème'},
    {'matiere': 'Maths', 'niveau': '5ème'},
    {'matiere': 'Maths', 'niveau': '4ème'},
    {'matiere': 'Maths', 'niveau': '3ème'},
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  
  // Méthode pour naviguer vers les détails d'une classe
  void goToClasseDetails(String matiere, String niveau) {
    Get.toNamed(
      '/class-teacher-details',
      arguments: {
        'className': 'Classe de $matiere',
        'classLevel': niveau,
      },
    );
  }
}
