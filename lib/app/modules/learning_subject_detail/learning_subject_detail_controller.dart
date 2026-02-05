import 'package:get/get.dart';
import '../../data/models/document_model.dart';
import '../../data/providers/document_provider.dart';
import '../../data/providers/api_provider.dart';

class LearningSubjectDetailController extends GetxController {
  final DocumentProvider documentProvider = DocumentProvider(Get.find<ApiProvider>());
  
  final RxList<DocumentModel> courses = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString subjectName = ''.obs;
  
  // Stats
  final RxInt hearts = 0.obs;
  final RxInt lightning = 1.obs;
  final RxInt fire = 15.obs;
  final RxDouble progress = 0.15.obs;
  
  // Configuration des trimestres (nombre de cours par trimestre)
  int get coursesPerTrimester => 4; // Par défaut 4 cours par trimestre
  
  // Calcul des bornes de chaque trimestre
  int get trimestre1Count => courses.length >= coursesPerTrimester ? coursesPerTrimester : courses.length;
  int get trimestre2Count => courses.length > trimestre1Count ? 
    (courses.length - trimestre1Count >= coursesPerTrimester ? coursesPerTrimester : courses.length - trimestre1Count) : 0;
  int get trimestre3Count => courses.length > (trimestre1Count + trimestre2Count) ? 
    courses.length - trimestre1Count - trimestre2Count : 0;
  
  // Récupérer les cours d'un trimestre spécifique
  List<DocumentModel> getCoursesForTrimester(int trimesterNumber) {
    switch (trimesterNumber) {
      case 1:
        return courses.take(trimestre1Count).toList();
      case 2:
        return courses.skip(trimestre1Count).take(trimestre2Count).toList();
      case 3:
        return courses.skip(trimestre1Count + trimestre2Count).toList();
      default:
        return [];
    }
  }
  
  @override
  void onInit() {
    super.onInit();
    // Get subject name from arguments
    if (Get.arguments != null && Get.arguments['subjectName'] != null) {
      subjectName.value = Get.arguments['subjectName'];
      fetchCourses();
    }
  }
  
  Future<void> fetchCourses() async {
    try {
      isLoading.value = true;
      
      // Fetch courses for the specific subject
      final response = await documentProvider.getAll(params: {
        'matiere': subjectName.value,
        'type': 'cours',
        'visibilite': 'public',
      });
      
      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'] ?? [];
        courses.value = data.map((json) => DocumentModel.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les cours',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Determine course status based on index (for demo purposes)
  // In a real app, this would come from user progress data
  String getCourseStatus(int index) {
    if (index == 0) return 'completed';
    if (index == 1) return 'current';
    return 'locked';
  }
  
  void onCourseTap(DocumentModel course, int index) {
    String status = getCourseStatus(index);
    
    if (status == 'locked') {
      Get.snackbar(
        'Cours verrouillé',
        'Complétez les cours précédents pour débloquer',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Navigate to course detail or start learning
      Get.snackbar(
        'Ouvrir le cours',
        course.titre,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Sauter au trimestre suivant (fonctionnalité "Trop facile")
  void skipToTrimester(int trimesterNumber) {
    // Navigation directe vers la page de test de compétence
    Get.toNamed('/competence-test', arguments: {
      'subjectName': subjectName.value,
      'trimesterNumber': trimesterNumber,
    });
  }
}
