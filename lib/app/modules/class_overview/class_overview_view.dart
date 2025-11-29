import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'class_overview_controller.dart';

class ClassOverviewView extends GetView<ClassOverviewController> {
  const ClassOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF8),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu principal
          SafeArea(
            child: Column(
              children: [
                // AppBar personnalisé
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: SC_ThemeColors.darkBlue,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: controller.goBack,
                      ),
                      const Expanded(
                        child: Text(
                          "Panorama de mes classes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 48), 
                    ],
                  ),
                ),

                // Contenu scrollable unique
                Expanded(
                  child: _buildPage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- PAGE ----------
  Widget _buildPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...controller.classes.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> classe = entry.value;
              
              return Column(
                children: [
                  _buildClasseSection(
                    classe['niveau'],
                    classe['evolution'],
                  ),
                  if (index < controller.classes.length - 1) ...[
                    const SizedBox(height: 30),
                    _buildSeparator(),
                    const SizedBox(height: 20),
                  ],
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// ---------- TITRE + CARTE ----------
  Widget _buildClasseSection(String titre, Map<String, double> evolution) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titre,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildClasseCard(evolution),
      ],
    );
  }

  /// ---------- CARTE ----------
  Widget _buildClasseCard(Map<String, double> evolution) {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          _buildMiniBarChart(evolution),
          const SizedBox(height: 12),
          const Text(
            "Evolution de la classe",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// ---------- MINI GRAPHIQUE ----------
  Widget _buildMiniBarChart(Map<String, double> evolution) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _bar("Faibles", Colors.redAccent, evolution['faibles']!),
        _bar("Moyens", Colors.blue, evolution['moyens']!),
        _bar("Évolués", Colors.green, evolution['evolues']!),
      ],
    );
  }

  Widget _bar(String label, Color color, double height) {
    return Column(
      children: [
        Container(
          width: 35,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }

  /// ---------- SÉPARATEUR ----------
  Widget _buildSeparator() {
    return Container(
      width: double.infinity,
      height: 1.2,
      color: Colors.black54,
    );
  }
}
