import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/classe_model.dart';
import 'package:scai_tutor_mobile/app/data/repositories/classe_repository.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class AddClassController extends GetxController {
  final ClasseRepository _classeRepository = ClasseRepository();
  final UserService _userService = Get.find<UserService>();
  
  final RxBool isLoading = false.obs;
  final classNameController = TextEditingController();
  final establishmentController = TextEditingController();
  final descriptionController = TextEditingController();

  final selectedLevel = Rxn<String>();
  final selectedSubject = Rxn<String>();

  final levels = <String>[
    "6ème",
    "5ème",
    "4ème",
    "3ème",
    "2nde",
    "1ère",
    "Tle",
  ];

  final subjects = <String>[
    "Mathématiques",
    "Physique",
    "Histoire",
    "Anglais",
  ];

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    classNameController.dispose();
    establishmentController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void goBack() {
    Get.back();
  }

  Future<void> createClass() async {
    // Validation du formulaire
    if (classNameController.text.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez saisir le nom de la classe',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedLevel.value == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner un niveau scolaire',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedSubject.value == null) {
      Get.snackbar(
        'Erreur',
        'Veuillez sélectionner une matière',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Récupérer l'ID de l'enseignant connecté
      final userId = _userService.user?.id;
      if (userId == null) {
        Get.snackbar(
          'Erreur',
          'Utilisateur non connecté',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Créer l'objet ClasseModel avec les données du formulaire
      final newClasse = ClasseModel(
        nomClasse: classNameController.text.trim(),
        niveauScolaire: selectedLevel.value,
        idEnseignant: userId,
      );

      // Appeler l'API pour créer la classe
      final createdClasse = await _classeRepository.create(newClasse);

      // Afficher le succès
      Get.snackbar(
        'Succès',
        'Classe créée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );

      // Rediriger vers la page d'invitation avec les informations de la classe créée
      Get.offNamed(
        Routes.CLASS_INVITATION_FROM_TEACHER,
        arguments: {
          'classeId': createdClasse.id,
          'className': createdClasse.nomClasse,
          'classLevel': createdClasse.niveauScolaire ?? '',
        },
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de créer la classe: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
