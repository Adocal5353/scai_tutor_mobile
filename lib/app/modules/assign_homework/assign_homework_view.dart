import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'assign_homework_controller.dart';

class AssignHomeworkView extends GetView<AssignHomeworkController> {
  const AssignHomeworkView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),

      /// AppBar
      appBar: AppBar(
        backgroundColor: SC_ThemeColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: controller.goBack,
        ),
        title: const Text(
          'Assigner des devoirs',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: controller.fetchEvaluations,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              /// BOUTON PRINCIPAL
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.assignPracticeQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SC_ThemeColors.normalGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Donner des quiz pratiques",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// LISTE DES DEVOIRS
              Obx(
                () => Column(
                  children: controller.homeworks.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> homework = entry.value;
                    
                    return _buildHomeworkItem(
                      titre: homework['titre'],
                      date: homework['date'],
                      onTap: () => controller.openHomework(index),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 25),

              /// BOUTON UPLOAD
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.uploadDocument,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: SC_ThemeColors.normalGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.file_upload_outlined, color: Colors.white, size: 32),
                      SizedBox(height: 6),
                      Text(
                        "Charger un document à vendre",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- WIDGET DEVOIR ----------
  Widget _buildHomeworkItem({
    required String titre,
    required String date,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        onTap: onTap,
        title: Text(
          titre,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "Délais de Soumission : $date",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, size: 28),
      ),
    );
  }
}
