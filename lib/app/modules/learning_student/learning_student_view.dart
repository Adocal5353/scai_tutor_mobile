import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'learning_student_controller.dart';

class LearningStudentView extends GetView<LearningStudentController> {
  const LearningStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color headerBlue = Color(0xFF1E4CE7);

    return Scaffold(
      backgroundColor: headerBlue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: controller.goBack,
        ),
        title: const Text(
          "Apprentissage",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Choisissez une matiere",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Afficher les matières principales
                    ...controller.mainSubjects.map((subject) => Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: _buildSubjectButton(
                        label: subject['name'],
                        color: Color(subject['color']),
                        textColor: Color(subject['textColor']),
                        iconName: subject['icon'],
                        iconColor: Color(subject['iconColor']),
                      ),
                    )).toList(),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectButton({
    required String label,
    required Color color,
    required Color textColor,
    required String iconName,
    required Color iconColor,
  }) {
    IconData icon;
    switch (iconName) {
      case 'calculate':
        icon = Icons.calculate_outlined;
        break;
      case 'atom':
        icon = Icons.blur_on;
        break;
      case 'science':
        icon = Icons.science;
        break;
      default:
        icon = Icons.book;
    }

    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => controller.selectSubject(label),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: iconColor,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
