import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';

import 'dashboard_teacher_controller.dart';

class DashboardTeacherView extends GetView<DashboardTeacherController> {
  const DashboardTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: SC_ThemeColors.darkBlue,
            unselectedItemColor: Colors.grey[600],
            showUnselectedLabels: true,
            elevation: 0,
            iconSize: 26,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Icon(Icons.home, weight: 700, size: 26),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Icon(Icons.home, weight: 700, size: 26),
                ),
                label: 'Bord',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Image.asset(
                    'assets/icons/classe.png',
                    width: 26,
                    height: 26,
                    color: Colors.grey[600],
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Image.asset(
                    'assets/icons/classe.png',
                    width: 26,
                    height: 26,
                    color: SC_ThemeColors.darkBlue,
                  ),
                ),
                label: 'Classe',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Image.asset(
                    'assets/icons/ressources.png',
                    width: 26,
                    height: 26,
                    color: Colors.grey[600],
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Image.asset(
                    'assets/icons/ressources.png',
                    width: 26,
                    height: 26,
                    color: SC_ThemeColors.darkBlue,
                  ),
                ),
                label: 'Ressources',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Image.asset(
                    'assets/icons/profil.png',
                    width: 26,
                    height: 26,
                    color: Colors.grey[600],
                  ),
                ),
                activeIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Image.asset(
                    'assets/icons/profil.png',
                    width: 26,
                    height: 26,
                    color: SC_ThemeColors.darkBlue,
                  ),
                ),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
