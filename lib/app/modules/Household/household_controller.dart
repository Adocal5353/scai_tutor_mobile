import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/apprenant_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';

class HouseholdController extends GetxController {
  final apprenants = <ApprenantModel>[].obs;
  final selectedChildIndex = Rxn<int>();
  final isLoading = false.obs;

  late final ApiProvider _apiProvider;

  @override
  void onInit() {
    super.onInit();
    _apiProvider = Get.find<ApiProvider>();
    _loadApprenants();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> _loadApprenants() async {
    try {
      isLoading.value = true;
      
      // Récupérer les apprenants du parent connecté
      final response = await _apiProvider.get('/apprenants');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        apprenants.value = data.map((json) => ApprenantModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les apprenants: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      // Données de démonstration en cas d'erreur
      _loadDemoData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDemoData() {
    apprenants.value = [
      ApprenantModel(
        id: '1',
        nom: 'AFANVI',
        prenom: 'Juliette',
        email: 'juliette@example.com',
        niveauScolaire: '6ème',
        origineCreation: 'invitation',
      ),
      ApprenantModel(
        id: '2',
        nom: 'AFANVI',
        prenom: 'Joseph',
        email: 'joseph@example.com',
        niveauScolaire: '5ème',
        origineCreation: 'directe',
      ),
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

  String getChildAvatar(int index) {
    // Alternance entre icônes masculin/féminin
    return index % 2 == 0 ? 'assets/icons/justine.png' : 'assets/icons/justin.png';
  }

  String getChildStatus(ApprenantModel apprenant) {
    if (apprenant.origineCreation == 'invitation') {
      return 'Récemment inscrit';
    } else {
      return 'Inscrit et à jour';
    }
  }

  bool isChildRegistered(ApprenantModel apprenant) {
    return apprenant.origineCreation == 'directe';
  }
}
