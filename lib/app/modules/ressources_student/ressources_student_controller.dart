import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/document_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/document_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';

class RessourcesStudentController extends GetxController {
  final DocumentProvider _documentProvider = DocumentProvider(Get.find<ApiProvider>());

  final RxList<DocumentModel> allDocuments = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  List<Map<String, dynamic>> get documents => allDocuments
    .where((doc) => doc.type != 'video' && doc.visibilite == 'public')
    .map((doc) => {
      'title': doc.titre,
      'date': DateTime.now(),
      'type': doc.type.toUpperCase(),
      'size': '0 MB',
      'document': doc,
    }).toList()
    ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

  List<Map<String, dynamic>> get videos => allDocuments
    .where((doc) => doc.type == 'video' && doc.visibilite == 'public')
    .map((doc) => {
      'title': doc.titre,
      'date': DateTime.now(),
      'duration': '0:00',
      'thumbnailUrl': 'https://via.placeholder.com/548x308',
      'document': doc,
    }).toList()
    ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

  @override
  void onInit() {
    super.onInit();
    fetchDocuments();
  }

  Future<void> fetchDocuments() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _documentProvider.getAll();

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        allDocuments.value = data
          .map((json) => DocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger les documents',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
