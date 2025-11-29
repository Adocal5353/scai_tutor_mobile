import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';

import 'ressources_teacher_controller.dart';

class RessourcesTeacherView extends GetView<RessourcesTeacherController> {
  const RessourcesTeacherView({super.key});
  
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
              // Bande blanche supérieure avec header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const Text(
                      "Ressources",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.arrow_upward,
                          color: Colors.black, size: 30),
                      onPressed: () {
                        Get.snackbar(
                          'Exportation',
                          'Fonctionnalité d\'exportation à implémenter',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ],
                ),
              ),
              // TabBar avec fond blanc
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: controller.tabController,
                  indicatorColor: SC_ThemeColors.darkBlue,
                  labelColor: SC_ThemeColors.darkBlue,
                  unselectedLabelColor: Colors.black54,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  tabs: const [
                    Tab(text: "Documents"),
                    Tab(text: "Vidéos"),
                  ],
                ),
              ),
              // Corps avec TabBarView
              Expanded(
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    // Onglet Documents
                    _buildDocumentsTab(),
                    // Onglet Vidéos
                    _buildVideosTab(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab() {
    final groupedDocs = controller.getGroupedDocuments();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          // Afficher les documents groupés par date
          ...groupedDocs.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                ...entry.value.map((doc) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildDocumentCard(
                    icon: doc['icon'] as IconData,
                    iconColor: doc['iconColor'] as Color,
                    title: doc['title'] as String,
                    type: doc['type'] as String,
                  ),
                )),
                const SizedBox(height: 8),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDocumentCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String type,
  }) {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          'Document',
          'Ouverture de: $title',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 15,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.check, color: Colors.black54, size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    final groupedVideos = controller.getGroupedVideos();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          // Afficher les vidéos groupées par date
          ...groupedVideos.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                ...entry.value.map((video) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildVideoCard(
                    title: video['title'] as String,
                    thumbnail: video['thumbnail'] as String,
                    duration: video['duration'] as String,
                    watched: video['watched'] as bool,
                  ),
                )),
                const SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildVideoCard({
    required String title,
    required String thumbnail,
    required String duration,
    required bool watched,
  }) {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          'Vidéo',
          'Lecture de: $title',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Thumbnail de la vidéo (ou placeholder)
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          SC_ThemeColors.darkBlue.withOpacity(0.7),
                          SC_ThemeColors.normalGreen.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 80,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  
                  // Icône lecture centrée
                  const Positioned.fill(
                    child: Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  
                  // Durée en bas à gauche
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  
                  // Coche si vidéo regardée
                  if (watched)
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: SC_ThemeColors.normalGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
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

