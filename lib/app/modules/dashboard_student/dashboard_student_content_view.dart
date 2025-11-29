import 'package:flutter/material.dart';
import 'package:scai_tutor_mobile/app/global_widgets/header_logo.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import '../../routes/app_pages.dart';

class DashboardStudentContentView extends StatelessWidget {
  const DashboardStudentContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HeaderLogo(),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 35, right: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  'MON TABLEAU DE BORD',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Section Librairie & Apprentissage
              Row(
                children: [
                  _buildMainCard(
                    title: 'Librairie',
                    icon: Icons.library_books,
                    color: SC_ThemeColors.darkBlue,
                  ),
                  const SizedBox(width: 40),
                  _buildMainCard(
                    title: 'Apprentissage',
                    icon: Icons.school,
                    color: SC_ThemeColors.darkBlue,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Section Évaluations - SUR LA MÊME LIGNE
              const Text(
                'Évaluations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 120, // Hauteur fixe pour la ligne d'évaluations
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildEvaluationCard('Evaluation en Mathematiques'),
                    const SizedBox(width: 18),
                    _buildEvaluationCard('Evaluation en physique'),
                    const SizedBox(width: 18),
                    _buildEvaluationCard('Evaluation en chimie'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.toNamed('/general-evaluation');
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: SC_ThemeColors.lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Evaluation générale",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
              // Section Évaluation Générale
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGeneralCard(
                    title: 'Statistiques',
                    icon: Icons.bar_chart,
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed('/sc-ai-bot');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: SC_ThemeColors.normalGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.chat, size: 70, color: Colors.white),
                              const SizedBox(height: 15),
                              Text(
                                "ScAI bot",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: SC_ThemeColors.lightBlue,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEvaluationCard(String title) {
    return Container(
      width: 100, // Largeur fixe pour chaque carte d'évaluation
      decoration: BoxDecoration(
        color: SC_ThemeColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.picture_as_pdf,
                color: SC_ThemeColors.darkBlue,
                size: 40,
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralCard({required String title, required IconData icon}) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: SC_ThemeColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SC_ThemeColors.darkBlue, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 70, color: SC_ThemeColors.darkBlue),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
