import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/apprenant_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/apprenant_provider.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class ClassStudentsListController extends GetxController {
  final ApprenantProvider _apprenantProvider = Get.find<ApprenantProvider>();

  final className = ''.obs;
  final classLevel = ''.obs;
  final classeId = ''.obs;

  final RxList<ApprenantModel> students = <ApprenantModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    print('[ClassStudentsList] Arguments recus: $args');
    
    if (args != null) {
      className.value = args['className'] ?? 'Classe';
      classLevel.value = args['classLevel'] ?? '';
      classeId.value = args['classeId'] ?? '';
      
      print('[ClassStudentsList] Classe initialisee:');
      print('  - className: ${className.value}');
      print('  - classLevel: ${classLevel.value}');
      print('  - classeId: "${classeId.value}"');
      
      if (classeId.value.isNotEmpty) {
        fetchStudents();
      } else {
        print('[ClassStudentsList] ATTENTION: classeId est vide!');
        error.value = 'ID de classe manquant';
      }
    }
  }

  Future<void> fetchStudents() async {
    try {
      isLoading.value = true;
      error.value = '';

      print('[ClassStudentsList] Fetching students for class: ${classeId.value}');
      
      final response = await _apprenantProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? response.data['apprenants'] ?? []);
        
        final allStudents = data
          .map((json) => ApprenantModel.fromJson(json as Map<String, dynamic>))
          .toList();
        
        print('[ClassStudentsList] Total students from API: ${allStudents.length}');
        
        // Filtrer les étudiants de cette classe
        students.value = allStudents
          .where((student) => student.idClasse == classeId.value)
          .toList();
        
        print('[ClassStudentsList] Filtered students for class ${classeId.value}: ${students.length}');
      } else {
        students.value = [];
        print('[ClassStudentsList] No data returned from API');
      }
    } catch (e) {
      error.value = 'Impossible de charger les étudiants';
      print('[ClassStudentsList] Error fetching students: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger la liste des étudiants',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  void navigateToClassChat() {
    print('[ClassStudentsList] Navigating to class chat');
    Get.toNamed(
      Routes.CLASS_CHAT,
      arguments: {
        'classeId': classeId.value,
        'className': className.value,
        'classLevel': classLevel.value,
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}
