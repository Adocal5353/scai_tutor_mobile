import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/modules/class_teacher_details/class_teacher_details_controller.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class ClassTeacherDetailsSeeMoreView extends StatelessWidget {
  const ClassTeacherDetailsSeeMoreView({super.key});

  void _inviteStudent() {
    final controller = Get.find<ClassTeacherDetailsController>();
    Get.back();
    Get.toNamed(
      '/class-invitation-from-teacher',
      arguments: {
        'classeId': controller.classeId.value,
        'className': controller.className.value,
        'classLevel': controller.classLevel.value,
      },
    );
  }

  void _viewStudents() {
    final controller = Get.find<ClassTeacherDetailsController>();
    Get.back();
    Get.toNamed(
      Routes.CLASS_STUDENTS_LIST,
      arguments: {
        'classeId': controller.classeId.value,
        'className': controller.className.value,
        'classLevel': controller.classLevel.value,
      },
    );
  }

  void _deleteClass() {
    Get.back();
    
    Get.defaultDialog(
      title: 'Supprimer la classe',
      middleText: 'Êtes-vous sûr de vouloir supprimer cette classe ? Cette action est irréversible.',
      textConfirm: 'Supprimer',
      textCancel: 'Annuler',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      cancelTextColor: Colors.black54,
      onConfirm: () {
        final controller = Get.find<ClassTeacherDetailsController>();
        controller.deleteClass();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// --- GRABBER ---
          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(50),
            ),
          ),

          const SizedBox(height: 20),

          _MenuItem(
            icon: Icons.link,
            label: "Inviter un élève",
            onTap: _inviteStudent,
          ),
          _MenuItem(
            icon: Icons.group,
            label: "Mes élèves",
            onTap: _viewStudents,
          ),
          _MenuItem(
            icon: Icons.delete,
            label: "Supprimer la classe",
            onTap: _deleteClass,
            isDestructive: true,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDestructive ? Colors.red.shade50 : const Color(0xFFE8EBF5),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : const Color(0xFF3D5AFE),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDestructive ? Colors.red : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
