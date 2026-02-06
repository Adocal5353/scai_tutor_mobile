import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:scai_tutor_mobile/app/data/models/Classe.dart';
import 'package:scai_tutor_mobile/app/data/providers/classe_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';

class ClassStudentController extends GetxController {
  final ClasseProvider _classeProvider = ClasseProvider(Get.find<ApiProvider>());

  final RxList<Map<String, dynamic>> classes = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClasses();
  }

  Future<void> fetchClasses() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _classeProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        final classesData = data.map((json) {
          final classe = Classe.fromJson(json as Map<String, dynamic>);
          return {
            'classe': classe,
            'color': _getColorForSubject(classe.subject),
            'icon': _getIconForSubject(classe.subject),
          };
        }).toList();

        classes.value = classesData;
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les classes',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Color _getColorForSubject(String subject) {
    final subjectLower = subject.toLowerCase();
    if (subjectLower.contains('math')) return Colors.blue;
    if (subjectLower.contains('phys')) return Colors.green;
    if (subjectLower.contains('chim')) return Colors.orange;
    if (subjectLower.contains('fran')) return Colors.purple;
    if (subjectLower.contains('ang')) return Colors.red;
    return Colors.teal;
  }

  IconData _getIconForSubject(String subject) {
    final subjectLower = subject.toLowerCase();
    if (subjectLower.contains('math')) return FontAwesomeIcons.squareRootVariable;
    if (subjectLower.contains('phys')) return FontAwesomeIcons.atom;
    if (subjectLower.contains('chim')) return FontAwesomeIcons.flaskVial;
    if (subjectLower.contains('fran')) return FontAwesomeIcons.book;
    if (subjectLower.contains('ang')) return FontAwesomeIcons.language;
    return FontAwesomeIcons.graduationCap;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
