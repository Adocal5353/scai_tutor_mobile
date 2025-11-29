import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_teacher_content_view.dart';
import 'package:scai_tutor_mobile/app/modules/profile/profile_view.dart';
import 'package:scai_tutor_mobile/app/modules/class_teacher/class_teacher_view.dart';
import 'package:scai_tutor_mobile/app/modules/ressources_teacher/ressources_teacher_view.dart';

class DashboardTeacherController extends GetxController {
  var currentIndex = 0.obs;
  
  final List<Widget> pages = [
    const DashboardTeacherContentView(),
    const ClassTeacherView(),
    const RessourcesTeacherView(),
    const ProfileView(),
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
}
