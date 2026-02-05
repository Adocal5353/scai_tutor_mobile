import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'class_students_list_controller.dart';

class ClassStudentsListView extends GetView<ClassStudentsListController> {
  const ClassStudentsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 20),
                decoration: BoxDecoration(
                  color: SC_ThemeColors.darkBlue,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white, size: 20),
                            onPressed: controller.goBack,
                          ),
                          Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  controller.className.value,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  controller.classLevel.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48),
                        ],
                      ),
                      
                      const SizedBox(height: 15),
                      
                      const Text(
                        "Liste des étudiants",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value && controller.students.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (controller.error.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 60,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.error.value,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: controller.fetchStudents,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SC_ThemeColors.normalGreen,
                            ),
                            child: const Text('Réessayer'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.students.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Aucun étudiant dans cette classe',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchStudents,
                    color: SC_ThemeColors.normalGreen,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.students.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final student = controller.students[index];
                        return _buildStudentCard(student);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.navigateToClassChat,
        backgroundColor: SC_ThemeColors.normalGreen,
        icon: const Icon(Icons.chat, color: Colors.white),
        label: const Text(
          'Discussion',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(student) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: SC_ThemeColors.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${student.prenom[0].toUpperCase()}${student.nom[0].toUpperCase()}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: SC_ThemeColors.darkBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${student.prenom} ${student.nom}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  student.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                if (student.niveauScolaire != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    student.niveauScolaire!,
                    style: TextStyle(
                      fontSize: 12,
                      color: SC_ThemeColors.darkBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
