import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/document_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/document_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/api_provider.dart';

class LibraryStudentController extends GetxController with GetSingleTickerProviderStateMixin {
  final DocumentProvider _documentProvider = DocumentProvider(Get.find<ApiProvider>());

  late TabController tabController;
  final RxList<DocumentModel> allBooks = <DocumentModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedSubject = 'Tout'.obs;

  final List<String> subjects = ['Tout', 'Mathématiques', 'Physique', 'Chimie'];

  // Filter books by selected subject
  List<DocumentModel> get filteredBooks {
    if (selectedSubject.value == 'Tout') {
      return allBooks;
    }
    return allBooks.where((book) => book.matiere == selectedSubject.value).toList();
  }

  // Get paid books only
  List<DocumentModel> get paidBooks {
    return filteredBooks.where((book) => book.estPayant == true).toList();
  }

  // Get free books only
  List<DocumentModel> get freeBooks {
    return filteredBooks.where((book) => book.estPayant == false).toList();
  }

  // Get most purchased books (sorted by price - higher price suggests popularity)
  List<DocumentModel> get mostPurchasedBooks {
    final books = filteredBooks.toList();
    books.sort((a, b) => (b.prix ?? 0).compareTo(a.prix ?? 0));
    return books.take(10).toList();
  }

  // Get recent books
  List<DocumentModel> get recentBooks {
    return filteredBooks.take(10).toList();
  }

  // Get all courses and exercises
  List<DocumentModel> get coursesAndExercises {
    return filteredBooks.where((book) => 
      book.type == 'cours' || book.type == 'exercice'
    ).toList();
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: subjects.length, vsync: this);
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Fetch all public documents (both free and paid)
      final response = await _documentProvider.getAll(
        params: {
          'visibilite': 'public',
        }
      );

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? []);
        
        allBooks.value = data
          .map((json) => DocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Erreur',
        'Impossible de charger la librairie',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void goBack() {
    Get.back();
  }

  void openBook(DocumentModel book) {
    Get.snackbar(
      'Livre',
      'Ouverture de: ${book.titre}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
