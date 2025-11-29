import 'package:get/get.dart';

class SubmissionsController extends GetxController {
  // Données des soumissions par classe
  final submissions = <Map<String, dynamic>>[
    {
      'niveau': '3ème',
      'devoirs': [
        {
          'titre': 'Recherche : Théorème de Thalès',
          'temps': 'Soumis il y a 2h',
          'badge': '3',
        },
      ]
    },
    {
      'niveau': '4ème',
      'devoirs': [
        {
          'titre': 'Devoir 1 : Théorème de Thalès',
          'temps': 'Soumis il y a 32 min',
          'badge': '3',
        },
      ]
    },
    {
      'niveau': '5ème',
      'devoirs': [
        {
          'titre': 'Devoir 1 : Exo sur les droites',
          'temps': 'Soumis il y a 2 min',
          'badge': '3',
        },
      ]
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
