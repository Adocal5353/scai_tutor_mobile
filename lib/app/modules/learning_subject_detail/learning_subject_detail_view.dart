import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'learning_subject_detail_controller.dart';

class LearningSubjectDetailView extends GetView<LearningSubjectDetailController> {
  const LearningSubjectDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E4CE7),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Scrollable Content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF1565C0),
                      ),
                    );
                  }
                  
                  if (controller.courses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Aucun cours disponible',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                    child: Column(
                      children: [
                        // ========== TRIMESTRE 1 ==========
                        if (controller.trimestre1Count > 0) ...[
                          _buildTrimesterHeader("Premier trimestre", 1),
                          const SizedBox(height: 20),
                          
                          ...controller.getCoursesForTrimester(1).asMap().entries.map((entry) {
                            int localIndex = entry.key;
                            int globalIndex = localIndex;
                            var course = entry.value;
                            bool isLast = localIndex == controller.getCoursesForTrimester(1).length - 1;
                            return _buildCourseCard(course, globalIndex, isLast);
                          }).toList(),
                        ],
                        
                        // Section "Trop facile ?" entre trimestre 1 et 2
                        if (controller.trimestre2Count > 0) ...[
                          const SizedBox(height: 30),
                          _buildTrimesterSeparator("Trop facile ?", 2),
                        ],
                        
                        // ========== TRIMESTRE 2 ==========
                        if (controller.trimestre2Count > 0) ...[
                          const SizedBox(height: 30),
                          _buildTrimesterHeader("Deuxième trimestre", 2),
                          const SizedBox(height: 20),
                          
                          ...controller.getCoursesForTrimester(2).asMap().entries.map((entry) {
                            int localIndex = entry.key;
                            int globalIndex = controller.trimestre1Count + localIndex;
                            var course = entry.value;
                            bool isLast = localIndex == controller.getCoursesForTrimester(2).length - 1;
                            return _buildCourseCard(course, globalIndex, isLast);
                          }).toList(),
                        ],
                        
                        // Section "Trop facile ?" entre trimestre 2 et 3
                        if (controller.trimestre3Count > 0) ...[
                          const SizedBox(height: 30),
                          _buildTrimesterSeparator("Trop facile ?", 3),
                        ],
                        
                        // ========== TRIMESTRE 3 ==========
                        if (controller.trimestre3Count > 0) ...[
                          const SizedBox(height: 30),
                          _buildTrimesterHeader("Troisième trimestre", 3),
                          const SizedBox(height: 20),
                          
                          ...controller.getCoursesForTrimester(3).asMap().entries.map((entry) {
                            int localIndex = entry.key;
                            int globalIndex = controller.trimestre1Count + controller.trimestre2Count + localIndex;
                            var course = entry.value;
                            bool isLast = localIndex == controller.getCoursesForTrimester(3).length - 1;
                            return _buildCourseCard(course, globalIndex, isLast);
                          }).toList(),
                        ],
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Obx(() => Text(
                controller.subjectName.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
          const SizedBox(height: 20),
          
          // Main Title
          const Text(
            "Apprentissage\npersonnalisé",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),

          // Stats bar
          Row(
            children: [
              Obx(() => _buildStatBadge(Icons.favorite_border, controller.hearts.value.toString())),
              const SizedBox(width: 8),
              Obx(() => _buildStatBadge(Icons.flash_on, controller.lightning.value.toString())),
              const SizedBox(width: 8),
              Obx(() => _buildStatBadge(Icons.card_giftcard, controller.fire.value.toString())),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.toNamed('/pro-offer'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "PRO",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Progress bar
          Obx(() => ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: controller.progress.value,
              backgroundColor: Colors.white.withOpacity(0.9),
              color: const Color(0xFF4CAF50),
              minHeight: 8,
            ),
          )),
          const SizedBox(height: 25),
          
          // Section title "Premier trimestre"
          const Center(
            child: Text(
              "premier trimestre",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Container(width: 100, height: 1, color: Colors.white24),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
  
  Widget _buildStatBadge(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.black87),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCourseCard(dynamic course, int index, bool isLast) {
    String status = controller.getCourseStatus(index);
    
    Color iconBackgroundColor;
    IconData statusIcon;
    
    switch (status) {
      case 'completed':
        iconBackgroundColor = const Color(0xFF38B000);
        statusIcon = Icons.check;
        break;
      case 'current':
        iconBackgroundColor = const Color(0xFF1565C0);
        statusIcon = Icons.play_arrow;
        break;
      default: // locked
        iconBackgroundColor = const Color(0xFF9E9E9E);
        statusIcon = Icons.lock;
    }
    
    return Column(
      children: [
        GestureDetector(
          onTap: () => controller.onCourseTap(course, index),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: status == 'current'
                        ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                        : [],
                  ),
                  child: Icon(
                    statusIcon,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                
                // Course title
                Expanded(
                  child: Text(
                    course.titre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                
                // Expand arrow
                const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
              ],
            ),
          ),
        ),
        
        // Divider except for last item
        if (!isLast)
          Divider(color: Colors.grey[400], height: 1, thickness: 0.8),
      ],
    );
  }
  
  
  // Widget pour l'en-tête de chaque trimestre
  Widget _buildTrimesterHeader(String title, int trimesterNumber) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          width: 80,
          height: 1.5,
          color: Colors.white,
        ),
      ],
    );
  }
  
  // Widget pour la section "Trop facile ?" entre trimestres
  Widget _buildTrimesterSeparator(String text, int nextTrimesterNumber) {
    return Column(
      children: [
        Icon(
          Icons.fast_forward_rounded,
          size: 70,
          color: Colors.grey.withOpacity(0.3),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        OutlinedButton(
          onPressed: () => controller.skipToTrimester(nextTrimesterNumber),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF1E4CE7), width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          child: const Text(
            "SAUTEZ ICI",
            style: TextStyle(
              color: Color(0xFF1E4CE7),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
