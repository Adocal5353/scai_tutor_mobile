import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/modules/class_teacher_details_see_more/class_teacher_details_see_more_view.dart';

class ClassTeacherDetailsController extends GetxController {
  // Informations de la classe (reçues via arguments de navigation)
  final className = ''.obs;
  final classLevel = ''.obs;
  final searchQuery = ''.obs;

  // Exercices de la classe
  final newExercises = <String>[
    '1.  Géo : Géométrie dans l\'espace',
    '2.  Alg : Calcules littérales',
  ].obs;

  final sentExercises = <Map<String, dynamic>>[
    {
      'title': 'Suites numériques en arithmétique',
      'imagePath': 'assets/images/teacher_detail.png',
    },
    {
      'title': 'Les nombres complexes',
      'imagePath': 'assets/images/nombre_complexe.png',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Récupérer les arguments passés lors de la navigation
    final args = Get.arguments;
    if (args != null) {
      className.value = args['className'] ?? 'Classe';
      classLevel.value = args['classLevel'] ?? '';
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goBack() {
    Get.back();
  }

  void showMoreOptions() {
    Get.bottomSheet(
      const ClassTeacherDetailsSeeMoreView(),
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
    );
  }

  void onSearchTap() {
    Get.snackbar(
      'Info',
      'Recherche dans la classe',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void openExercise(int index) {
    Get.snackbar(
      'Info',
      'Ouvrir ${sentExercises[index]['title']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
