import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_student_controller.dart';

class DashboardStudentView extends GetView<DashboardStudentController> {
  const DashboardStudentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      backgroundColor: Colors.white,
      body: Obx(() => controller.pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue[800],
          unselectedItemColor: Colors.grey[600],
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Bord'),
            BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Classe'),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Ressources',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}
