import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassTeacherDetailsSeeMoreView extends StatelessWidget {
  const ClassTeacherDetailsSeeMoreView({super.key});

  void _inviteStudent() {
    Get.back();
    Get.toNamed('/class-invitation-from-teacher');
  }

  void _viewStudents() {
    Get.back();
    Get.toNamed('/class-chat');
  }

  void _leaveClass() {
    Get.back();
    Get.snackbar(
      'Info',
      'Quitter la classe',
      snackPosition: SnackPosition.BOTTOM,
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

          /// --- MENU ITEMS ---
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
            icon: Icons.logout,
            label: "Quitter",
            onTap: _leaveClass,
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

/// --- REUSABLE ITEM ---
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            /// --- ICON CIRCLE ---
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8EBF5),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF3D5AFE),
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            /// --- LABEL ---
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
