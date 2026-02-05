import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/classe.dart';
import 'package:scai_tutor_mobile/app/data/providers/document_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';

class UploadDocumentController extends GetxController {
  final DocumentProvider _documentProvider = Get.find<DocumentProvider>();
  final ClasseProvider _classeProvider = Get.find<ClasseProvider>();
  final UserService _userService = Get.find<UserService>();

  final TextEditingController titreController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController matiereController = TextEditingController();
  final TextEditingController prixController = TextEditingController();

  final RxList<Classe> classes = <Classe>[].obs;
  final Rxn<Classe> selectedClasse = Rxn<Classe>();
  
  final RxBool estPayant = false.obs;
  final RxString visibilite = 'public'.obs;
  
  final RxBool isLoading = false.obs;
  final RxBool isLoadingClasses = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      isLoadingClasses.value = true;
      print('[UploadDocument] Loading classes...');

      final response = await _classeProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        classes.value = data
          .map((json) => Classe.fromJson(json as Map<String, dynamic>))
          .toList();
        
        print('[UploadDocument] Loaded ${classes.length} classes');
      }
    } catch (e) {
      print('[UploadDocument] Error loading classes: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les classes',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingClasses.value = false;
    }
  }

  void togglePayant(bool value) {
    estPayant.value = value;
    if (!value) {
      prixController.clear();
    }
  }

  void setVisibilite(String value) {
    visibilite.value = value;
  }

  Future<void> uploadDocument() async {
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';

      final userId = _userService.user?.id;
      if (userId == null) {
        Get.snackbar(
          'Erreur',
          'Utilisateur non connecté',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final data = {
        'titre': titreController.text.trim(),
        'type': typeController.text.trim(),
        'matiere': matiereController.text.trim(),
        'est_payant': estPayant.value,
        'id_enseignant': userId,
        'id_classe': selectedClasse.value!.id,
        'visibilite': visibilite.value,
      };

      // Ajouter le prix si le document est payant
      if (estPayant.value) {
        data['prix'] = double.parse(prixController.text.trim());
      }

      print('[UploadDocument] Creating document with data: $data');

      await _documentProvider.create(data);

      print('[UploadDocument] Document created successfully');
      
      Get.snackbar(
        'Succès',
        'Document enregistré avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
      );

      Get.back(result: true);
    } catch (e) {
      error.value = e.toString();
      print('[UploadDocument] Error creating document: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'enregistrer le document',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (titreController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir un titre',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (typeController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir le type de document',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (matiereController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir la matière',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedClasse.value == null) {
      Get.snackbar(
        'Validation',
        'Veuillez sélectionner une classe',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (estPayant.value) {
      final prix = double.tryParse(prixController.text.trim());
      if (prix == null || prix <= 0) {
        Get.snackbar(
          'Validation',
          'Veuillez saisir un prix valide (supérieur à 0)',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    return true;
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    titreController.dispose();
    typeController.dispose();
    matiereController.dispose();
    prixController.dispose();
    super.onClose();
  }
}
