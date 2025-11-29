import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'class_teacher_details_controller.dart';

class ClassTeacherDetailsView extends GetView<ClassTeacherDetailsController> {
  const ClassTeacherDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// --- BACKGROUND IMAGE ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// --- CONTENT ---
          Column(
            children: [
              /// --- BLUE HEADER (FIXED) ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 20),
                decoration: BoxDecoration(
                  color: SC_ThemeColors.darkBlue,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      /// --- TOP BAR ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white, size: 20),
                            onPressed: controller.goBack,
                          ),
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  controller.className.value,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  controller.classLevel.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: controller.showMoreOptions,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      
                      /// --- SEARCH BAR ---
                      GestureDetector(
                        onTap: controller.onSearchTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.black54),
                              SizedBox(width: 10),
                              Text(
                                "Rechercher",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black54),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// --- SCROLLABLE CONTENT ---
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),

                    const SizedBox(height: 25),

                    /// --- NOUVEL EXERCICE / RECHERCHE ---
                    const Text(
                      "Nouvel Exercice / Recherche",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: SC_ThemeColors.darkBlue,
                            width: 1.3,
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.newExercises.map((exercise) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                exercise,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// --- ENVOYÉS HEADER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Envoyés",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "16 Avril",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// --- EXERCISE CARDS ---
                    Obx(
                      () => Column(
                        children: controller.sentExercises.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, dynamic> exercise = entry.value;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _ExerciseCard(
                              title: exercise['title'],
                              imagePath: exercise['imagePath'],
                              onTap: () => controller.openExercise(index),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// --- EXERCISE CARD WIDGET ---
class _ExerciseCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _ExerciseCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Image.asset(
                    imagePath,
                    width: constraints.maxWidth,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 160,
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
