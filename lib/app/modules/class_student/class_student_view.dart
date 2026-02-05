import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/modules/class_student/classCard.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';

import 'class_student_controller.dart';

class ClassStudentView extends StatelessWidget {
  ClassStudentView({super.key}) {
    // Initialize the controller
    Get.put(ClassStudentController());
  }

  @override
  Widget build(BuildContext context) {
    // Access the controller
    final ClassStudentController controller =
        Get.find<ClassStudentController>();

    return Scaffold(
      backgroundColor: SC_ThemeColors.darkBlue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec marge et texte
            Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mes classes",
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Container(height: 1, width: 100, color: SC_ThemeColors.white),
                ],
              ),
            ),

            // Section principale qui prend tout l'espace restant
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: SC_ThemeColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Choisissez l'une de vos classes à entrer",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Liste des classes
                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }
                        
                        if (controller.error.value.isNotEmpty) {
                          return Center(
                            child: Text(
                              'Erreur: ${controller.error.value}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }
                        
                        if (controller.classes.isEmpty) {
                          return const Center(
                            child: Text(
                              'Aucune classe disponible',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          );
                        }
                        
                        return ListView.separated(
                          itemCount: controller.classes.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemBuilder: (context, index) {
                            final classe = controller.classes[index];
                            return Classcard(
                              classe: classe['classe'],
                              color: classe['color'],
                              icon: classe['icon'],
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
