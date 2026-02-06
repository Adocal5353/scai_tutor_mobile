import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/modules/class_student/class_student_view.dart';
import 'package:scai_tutor_mobile/app/modules/dashboard_student/dashboard_student_content_view.dart';
import 'package:scai_tutor_mobile/app/modules/profile/profile_view.dart';
import 'package:scai_tutor_mobile/app/modules/ressources_student/ressources_student_view.dart';

class DashboardStudentController extends GetxController {
  //TODO: Implement DashboardStudentController

  final count = 0.obs;
  var currentIndex = 0.obs;
  final List<Widget> pages = [
    DashboardStudentContentView(),
    ClassStudentView(),
    RessourcesStudentView(),
    ProfileView(),
  ];

  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
