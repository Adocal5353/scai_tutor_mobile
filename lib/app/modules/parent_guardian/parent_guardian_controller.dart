import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class ParentGuardianController extends GetxController {
  var currentIndex = 0.obs;
  
  // Les pages seront définies depuis la vue pour éviter la dépendance circulaire
  List<Widget> pages = <Widget>[];

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

  void goToFoyer() {
    changeTab(1);
  }

  void goToScAIBot() {
    Get.toNamed(Routes.SCS_A_I_BOT);
  }
}
