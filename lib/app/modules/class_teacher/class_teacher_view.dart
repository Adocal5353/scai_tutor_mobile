import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';

import 'class_teacher_controller.dart';

class ClassTeacherView extends GetView<ClassTeacherController> {
  const ClassTeacherView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image pour toute la page
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                // En-tête avec fond bleu
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 30),
                  decoration: BoxDecoration(
                    color: SC_ThemeColors.darkBlue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Mes classes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 2,
                        width: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // Section principale arrondie qui passe sur l'AppBar
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F8FA),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        
                        // Titre et sous-titre alignés à gauche
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Choisissez l'une de vos classes\nà entrer",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 2,
                                width: 100,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),

                    const SizedBox(height: 30),

                    // Grille des classes
                    Expanded(
                      child: Obx(
                        () {
                          if (controller.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          
                          if (controller.error.value.isNotEmpty) {
                            return RefreshIndicator(
                              onRefresh: controller.fetchClasses,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Erreur: ${controller.error.value}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: controller.fetchClasses,
                                          child: const Text('Réessayer'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          if (controller.classes.isEmpty) {
                            return RefreshIndicator(
                              onRefresh: controller.fetchClasses,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: const Center(
                                    child: Text(
                                      'Aucune classe disponible',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          
                          return RefreshIndicator(
                            onRefresh: controller.fetchClasses,
                            child: GridView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 18,
                                crossAxisSpacing: 18,
                                childAspectRatio: 1.3, 
                              ),
                              itemCount: controller.classes.length,
                              itemBuilder: (context, index) {
                                final classe = controller.classes[index];
                                return _buildClasseCard(
                                  matiere: classe.subject,
                                  niveau: classe.level,
                                  index: index,
                                  onTap: () => controller.goToClasseDetails(classe),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget pour chaque classe
  Widget _buildClasseCard({
    required String matiere,
    required String niveau,
    required int index,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Carte principale
          Container(
            decoration: BoxDecoration(
              color: SC_ThemeColors.normalGreen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    matiere,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    niveau,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
