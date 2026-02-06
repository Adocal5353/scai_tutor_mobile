import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'package:scai_tutor_mobile/app/modules/Household/household_view.dart';
import 'package:scai_tutor_mobile/app/modules/profile/profile_view.dart';
import 'parent_guardian_controller.dart';

class ParentGuardianView extends GetView<ParentGuardianController> {
  const ParentGuardianView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialiser les pages ici pour éviter la dépendance circulaire
    if (controller.pages.isEmpty) {
      controller.pages = [
        const ParentGuardianContentView(),
        const HouseholdView(),
        const ProfileView(),
      ];
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: SC_ThemeColors.darkBlue,
          unselectedItemColor: Colors.grey[600],
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
            BottomNavigationBarItem(icon: Icon(Icons.family_restroom), label: 'Foyer'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}

class ParentGuardianContentView extends GetView<ParentGuardianController> {
  const ParentGuardianContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Expanded(
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// --- LOGO ---
                          Center(
                            child: Container(
                              height: 50,
                              width: 100,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Image.asset(
                                'assets/images/app_logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          const Center(
                            child: Text(
                              "Bienvenu cher Parent",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          /// --- FOYER BUTTON ---
                          GestureDetector(
                            onTap: controller.goToFoyer,
                            child: Container(
                              width: double.infinity,
                              height: 85,
                              decoration: BoxDecoration(
                                color: SC_ThemeColors.darkBlue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 25),
                                    child: Text(
                                      "Foyer",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 25),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          const Text(
                            "Besoin d'aide sur l'utilisation de l'application ?",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "Votre assistant est là pour vous aider.",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),

                          const SizedBox(height: 60),

                          /// --- SCAI BOT CARD ---
                          Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: controller.goToScAIBot,
                              child: Container(
                                height: 110,
                                width: 110,
                                decoration: BoxDecoration(
                                  color: SC_ThemeColors.normalGreen,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.chat_bubble, color: Colors.white, size: 40),
                                    SizedBox(height: 8),
                                    Text(
                                      "ScAI Bot",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
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
