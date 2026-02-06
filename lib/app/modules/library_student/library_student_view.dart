import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/document_model.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'library_student_controller.dart';

class LibraryStudentView extends GetView<LibraryStudentController> {
  const LibraryStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header with search bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: controller.goBack,
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F6FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        onChanged: controller.updateSearchQuery,
                        decoration: const InputDecoration(
                          hintText: 'Rechercher un livre...',
                          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                          prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Subject tabs
            Container(
              color: Colors.white,
              child: TabBar(
                controller: controller.tabController,
                isScrollable: true,
                indicatorColor: SC_ThemeColors.darkBlue,
                labelColor: SC_ThemeColors.darkBlue,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                onTap: (index) => controller.selectSubject(controller.subjects[index]),
                tabs: controller.subjects
                    .map((subject) => Tab(text: subject))
                    .toList(),
              ),
            ),

            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Erreur: ${controller.error.value}'),
                        ElevatedButton(
                          onPressed: controller.fetchBooks,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // PLUS ACHETÉS Section
                      Container(
                        color: const Color(0xFF1A56C4),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PLUS ACHETÉS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 240,
                              child: Obx(() => ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.mostPurchasedBooks.length,
                                itemBuilder: (context, index) {
                                  final book = controller.mostPurchasedBooks[index];
                                  return _buildBookCard(book);
                                },
                              )),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // RÉCENTS Section
                      Container(
                        color: const Color(0xFF1A56C4),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RÉCENTS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 240,
                              child: Obx(() => ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.recentBooks.length,
                                itemBuilder: (context, index) {
                                  final book = controller.recentBooks[index];
                                  return _buildBookCard(book);
                                },
                              )),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // COURS ET EXERCICES Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'COURS ET EXERCICES',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Obx(() => Column(
                              children: controller.coursesAndExercises
                                  .map((book) => _buildCourseCard(book))
                                  .toList(),
                            )),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(DocumentModel book) {
    return GestureDetector(
      onTap: () => controller.openBook(book),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book image placeholder
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(
                  _getIconForType(book.type),
                  size: 50,
                  color: SC_ThemeColors.darkBlue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.titre,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) => const Icon(
                        Icons.star,
                        size: 12,
                        color: Colors.amber,
                      )),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.estPayant == true
                      ? '${book.prix?.toStringAsFixed(0) ?? '0'} FCFA'
                      : 'GRATUIT',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: book.estPayant == true 
                        ? SC_ThemeColors.darkBlue
                        : const Color(0xFF28A745),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(DocumentModel book) {
    return GestureDetector(
      onTap: () => controller.openBook(book),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIconForType(book.type),
                size: 30,
                color: SC_ThemeColors.darkBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.titre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book.type.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) => const Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber,
                      )),
                      const Spacer(),
                      if (book.estPayant == true)
                        Text(
                          '${book.prix?.toStringAsFixed(0) ?? '0'} FCFA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: SC_ThemeColors.darkBlue,
                          ),
                        )
                      else
                        Text(
                          'GRATUIT',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF28A745),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'cours':
        return Icons.book;
      case 'exercice':
        return Icons.edit_note;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.description;
    }
  }
}
