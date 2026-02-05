import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'dashboard_teacher_controller.dart';

class DashboardTeacherContentView extends StatelessWidget {
  const DashboardTeacherContentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardTeacherController>();
    
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          Column(
            children: [
              // Bande bleue supérieure avec header (réduite)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
                decoration: BoxDecoration(
                  color: SC_ThemeColors.darkBlue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // En-tête avec logo et cloche
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35,
                          width: 80,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              'assets/icons/notifications.png',
                              width: 28,
                              height: 28,
                              color: Colors.white,
                            ),
                            Positioned(
                              top: -5,
                              right: -5,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  "7",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Informations utilisateur dans l'AppBar
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/icons/utilisateur.png',
                            width: 35,
                            height: 35,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                controller.userName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              const SizedBox(height: 2),
                              Obx(() => Text(
                                controller.specialiteNiveau,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 13,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Contenu scrollable
              Expanded(
                child: Stack(
                  children: [
                    // Logos transparents en arrière-plan (positionnés absolument)
                    Positioned(
                      top: 60,
                      left: -50,
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            "assets/images/Scai_tutor_logo_transparant.png",
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 310,
                      right: -30,
                      child: Transform.rotate(
                        angle: 0.2,
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            "assets/images/Scai_tutor_logo_transparant.png",
                            width: 180,
                            height: 180,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 100,
                      left: 20,
                      child: Transform.rotate(
                        angle: -0.15,
                        child: Opacity(
                          opacity: 0.2,
                          child: Image.asset(
                            "assets/images/Scai_tutor_logo_transparant.png",
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    // Contenu scrollable par-dessus
                    SingleChildScrollView(
                      child: Transform.translate(
                        offset: const Offset(0, -40),
                        child: Column(
                          children: [
                            const SizedBox(height: 15),

                            // Grille des 4 boutons
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  _buildMenuCard(
                                    'assets/icons/plus.png',
                                    "Créer une classe",
                                    const Color(0xFF348337),
                                    context,
                                  ),
                                  _buildMenuCard(
                                    'assets/icons/quiz.png',
                                    "Quiz et documents",
                                    Colors.transparent,
                                    context,
                                  ),
                                  _buildMenuCard(
                                    'assets/icons/documents.png',
                                    "Ajouter des ressources",
                                    Colors.transparent,
                                    context,
                                  ),
                                  _buildMenuCard(
                                    'assets/icons/groupe_user.png',
                                    "Gérer mes élèves",
                                    Colors.transparent,
                                    context,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Voir les soumissions
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigation vers les soumissions
                                  Get.toNamed(Routes.SUBMISSIONS);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12.withOpacity(0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.play_arrow_rounded,
                                            color: SC_ThemeColors.darkBlue,
                                            size: 30,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            "Voir les soumissions",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: SC_ThemeColors.normalGreen,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          "7",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Panorama de classe
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: GestureDetector(
                                onTap: () {
                                  // Navigation vers panorama
                                  Get.toNamed('/class-overview');
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12.withOpacity(0.05),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.bar_chart,
                                        color: SC_ThemeColors.darkBlue,
                                        size: 30,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        "Panorama de classe",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),
                          ],
                        ),
                      ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    String iconPath,
    String title,
    Color color,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigation selon le titre
        if (title == "Quiz et documents") {
          Get.toNamed(Routes.ASSIGN_HOMEWORK);
        } else if (title == "Créer une classe") {
          Get.toNamed(Routes.ADD_CLASS);
        } else if (title == "Ajouter des ressources") {
          // Changer vers l'onglet Ressources du BottomNavigationBar (index 2)
          final controller = Get.find<DashboardTeacherController>();
          controller.changeTab(2);
        } else if (title == "Gérer mes élèves") {
          // Changer vers l'onglet Classes du BottomNavigationBar (index 1)
          final controller = Get.find<DashboardTeacherController>();
          controller.changeTab(1);
        } else {
          Get.snackbar(
            'Info',
            '$title - En développement',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            color == Colors.transparent
                ? Image.asset(
                    iconPath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  )
                : Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      iconPath,
                      width: 35,
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
