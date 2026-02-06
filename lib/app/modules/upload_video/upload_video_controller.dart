import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:scai_tutor_mobile/app/data/models/classe.dart';
import 'package:scai_tutor_mobile/app/data/providers/document_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';

class UploadVideoController extends GetxController {
  final DocumentProvider _documentProvider = Get.find<DocumentProvider>();
  final ClasseProvider _classeProvider = Get.find<ClasseProvider>();
  final UserService _userService = Get.find<UserService>();

  final TextEditingController titreController = TextEditingController();
  final TextEditingController matiereController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxList<Classe> classes = <Classe>[].obs;
  final Rxn<Classe> selectedClasse = Rxn<Classe>();
  
  final RxString visibilite = 'public'.obs;
  
  final Rxn<PlatformFile> selectedFile = Rxn<PlatformFile>();
  final RxString fileError = ''.obs;
  
  final RxBool isLoading = false.obs;
  final RxBool isLoadingClasses = false.obs;
  final RxString error = ''.obs;

  // Extensions vidéo acceptées
  static const List<String> VIDEO_EXTENSIONS = [
    'mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv', 'webm', 'm4v'
  ];
  
  // Taille max : 100 Mo pour les vidéos
  static const int MAX_VIDEO_SIZE = 100 * 1024 * 1024;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      isLoadingClasses.value = true;
      print('[UploadVideo] Loading classes...');

      final response = await _classeProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        classes.value = data
          .map((json) => Classe.fromJson(json as Map<String, dynamic>))
          .toList();
        
        print('[UploadVideo] Loaded ${classes.length} classes');
      }
    } catch (e) {
      print('[UploadVideo] Error loading classes: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les classes',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingClasses.value = false;
    }
  }

  void setVisibilite(String value) {
    visibilite.value = value;
  }

  Future<void> pickVideo() async {
    try {
      fileError.value = '';
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // Valider la taille (max 100Mo)
        if (file.size > MAX_VIDEO_SIZE) {
          fileError.value = 'La vidéo ne doit pas dépasser 100 Mo';
          Get.snackbar(
            'Fichier trop volumineux',
            'Veuillez sélectionner une vidéo de moins de 100 Mo',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        
        // Valider l'extension
        final extension = file.extension?.toLowerCase();
        if (extension == null || !VIDEO_EXTENSIONS.contains(extension)) {
          fileError.value = 'Format vidéo non supporté';
          Get.snackbar(
            'Format non supporté',
            'Formats acceptés: ${VIDEO_EXTENSIONS.join(", ")}',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
        
        selectedFile.value = file;
        print('[UploadVideo] Vidéo sélectionnée: ${file.name} (${file.size} octets)');
      }
    } catch (e) {
      print('[UploadVideo] Erreur sélection vidéo: $e');
      fileError.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner la vidéo',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeSelectedFile() {
    selectedFile.value = null;
    fileError.value = '';
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes o';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} Ko';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mo';
  }

  Future<void> uploadVideo() async {
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

      // Préparer FormData avec tous les champs
      final formDataMap = <String, dynamic>{
        'titre': titreController.text.trim(),
        'type': 'video',
        'matiere': matiereController.text.trim(),
        'est_payant': '0', // Les vidéos sont toujours gratuites
        'id_enseignant': userId,
        'id_classe': selectedClasse.value!.id,
        'visibilite': visibilite.value,
      };

      // Ajouter description si remplie
      if (descriptionController.text.trim().isNotEmpty) {
        formDataMap['description'] = descriptionController.text.trim();
      }

      // Ajouter fichier vidéo (obligatoire)
      if (selectedFile.value != null) {
        final file = selectedFile.value!;
        if (file.path != null) {
          formDataMap['fichier'] = await dio.MultipartFile.fromFile(
            file.path!,
            filename: file.name,
          );
          print('[UploadVideo] Inclusion vidéo: ${file.name}');
        }
      }

      final formData = dio.FormData.fromMap(formDataMap);

      print('[UploadVideo] Création vidéo avec FormData');
      print('[UploadVideo] Champs: ${formDataMap.keys.toList()}');

      await _documentProvider.create(formData);

      print('[UploadVideo] Vidéo créée avec succès');
      
      Get.snackbar(
        'Succès',
        'Vidéo enregistrée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
      );

      Get.back(result: true);
    } catch (e) {
      error.value = e.toString();
      print('[UploadVideo] Erreur création vidéo: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'enregistrer la vidéo',
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

    if (selectedFile.value == null) {
      Get.snackbar(
        'Validation',
        'Veuillez sélectionner une vidéo',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    titreController.dispose();
    matiereController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
