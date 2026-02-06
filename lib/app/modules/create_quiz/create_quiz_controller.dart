import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/matiere_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/evaluation_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/matiere_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:intl/intl.dart';

class CreateQuizController extends GetxController {
  final EvaluationProvider _evaluationProvider = Get.find<EvaluationProvider>();
  final MatiereProvider _matiereProvider = Get.find<MatiereProvider>();
  final UserService _userService = Get.find<UserService>();

  final TextEditingController titreController = TextEditingController();
  final TextEditingController chapitresController = TextEditingController();

  final RxList<MatiereModel> matieres = <MatiereModel>[].obs;
  final Rxn<MatiereModel> selectedMatiere = Rxn<MatiereModel>();
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMatieres = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMatieres();
  }

  Future<void> fetchMatieres() async {
    try {
      isLoadingMatieres.value = true;
      print('[CreateQuiz] Loading matieres...');

      final response = await _matiereProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        matieres.value = data
          .map((json) => MatiereModel.fromJson(json as Map<String, dynamic>))
          .toList();
        
        print('[CreateQuiz] Loaded ${matieres.length} matieres');
      }
    } catch (e) {
      print('[CreateQuiz] Error loading matieres: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les matières',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingMatieres.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (time != null) {
        selectedDate.value = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        print('[CreateQuiz] Date selected: ${selectedDate.value}');
      }
    }
  }

  Future<void> showCreateMatiereDialog(BuildContext context) async {
    final TextEditingController matiereController = TextEditingController();
    
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Ajouter une matière'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Entrez le nom de la nouvelle matière',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: matiereController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Ex: Mathématiques',
                filled: true,
                fillColor: const Color(0xFFF2F5F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (matiereController.text.trim().isEmpty) {
                Get.snackbar(
                  'Validation',
                  'Veuillez saisir un nom de matière',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF228A25),
            ),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );

    if (result == true && matiereController.text.trim().isNotEmpty) {
      await _createMatiere(matiereController.text.trim());
    }
    
    matiereController.dispose();
  }

  Future<void> _createMatiere(String nomMatiere) async {
    try {
      print('[CreateQuiz] Creating matiere: $nomMatiere');
      
      final data = {'nom_matiere': nomMatiere};
      await _matiereProvider.create(data);
      
      print('[CreateQuiz] Matiere created successfully');
      
      Get.snackbar(
        'Succès',
        'Matière ajoutée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
      );
      
      // Rafraîchir la liste des matières
      await fetchMatieres();
      
      // Sélectionner automatiquement la nouvelle matière créée
      if (matieres.isNotEmpty) {
        selectedMatiere.value = matieres.firstWhere(
          (m) => m.nomMatiere == nomMatiere,
          orElse: () => matieres.last,
        );
      }
    } catch (e) {
      print('[CreateQuiz] Error creating matiere: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de créer la matière',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> createQuiz() async {
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

      final dateCreation = DateFormat('yyyy-MM-ddTHH:mm:ss').format(selectedDate.value!);

      final data = {
        'titre': titreController.text.trim(),
        'date_creation': dateCreation,
        'chapitres_concernes': chapitresController.text.trim(),
        'id_enseignant': userId,
        'id_matiere': selectedMatiere.value!.id,
      };

      print('[CreateQuiz] Creating quiz with data: $data');

      await _evaluationProvider.create(data);

      print('[CreateQuiz] Quiz created successfully');
      
      Get.snackbar(
        'Succès',
        'Quiz créé avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
      );

      Get.back(result: true);
    } catch (e) {
      error.value = e.toString();
      print('[CreateQuiz] Error creating quiz: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de créer le quiz',
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

    if (selectedMatiere.value == null) {
      Get.snackbar(
        'Validation',
        'Veuillez sélectionner une matière',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (chapitresController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation',
        'Veuillez saisir les chapitres concernés',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedDate.value == null) {
      Get.snackbar(
        'Validation',
        'Veuillez sélectionner une date limite',
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
    chapitresController.dispose();
    super.onClose();
  }
}
