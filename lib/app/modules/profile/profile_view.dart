import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  
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
          Column(
            children: [
              // AppBar avec fond blanc
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
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
                    IconButton(
                      icon: const Icon(Icons.logout, color: Colors.black),
                      onPressed: controller.logout,
                      tooltip: 'Déconnexion',
                    ),
                  ],
                ),
              ),
              // Corps avec fond semi-transparent
              Expanded(
                child: Container(
                  color: Colors.white.withOpacity(0.95),
                  child: Obx(() => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Profile header with image and name
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/icons/utilisateur.png',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  controller.userName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                    Text(
                      controller.userEmail,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all<Color>(
                          SC_ThemeColors.normalGreen,
                        ),
                        foregroundColor: WidgetStateProperty.all<Color>(
                          Colors.white,
                        ),
                      ),
                      child: Text(
                        controller.userRole,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Profile modification button
            ElevatedButton(
              onPressed: controller.goToEditProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: SC_ThemeColors.lightBlueBg,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modifier le profil',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Classes button
            ElevatedButton(
              onPressed: controller.goToClasses,
              style: ElevatedButton.styleFrom(
                backgroundColor: SC_ThemeColors.lightBlueBg,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mes classes',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.black),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Upload video button (only for teachers)
            if (controller.userRole == 'Enseignant(e)')
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/upload-video')?.then((result) {
                    if (result == true) {
                      Get.snackbar(
                        'Succès',
                        'Vidéo uploadée avec succès',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF228A25),
                        colorText: Colors.white,
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SC_ThemeColors.lightBlueBg,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.video_library, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Charger une vidéo',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Upload document button (only for students)
            if (controller.userRole == 'Apprenant(e)')
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/upload-document')?.then((result) {
                    if (result == true) {
                      Get.snackbar(
                        'Succès',
                        'Document uploadé avec succès',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF228A25),
                        colorText: Colors.white,
                      );
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: SC_ThemeColors.lightBlueBg,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.upload_file, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          'Charger un document',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black),
                  ],
                ),
              ),
                      ],
                    ),
                  )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
