import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'competence_test_controller.dart';

class CompetenceTestView extends GetView<CompetenceTestController> {
  const CompetenceTestView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color ctaColor = Color(0xFF00B2D6);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BOUTON FERMER ---
              IconButton(
                icon: const Icon(Icons.close, size: 30, color: Colors.black),
                onPressed: controller.closeTest,
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),

              // --- CONTENU CENTRAL (Centré verticalement) ---
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Illustration personnalisée (Flèche avec bulles)
                    const _IllustrationFleche(),
                    
                    const SizedBox(height: 40),

                    // Titre
                    const Text(
                      "Pensez-vous déjà maitriser cette Partie ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    
                    const SizedBox(height: 16),

                    // Sous-titre dynamique
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Passez le test du ',
                            ),
                            TextSpan(
                              text: controller.getTrimesterLabel(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: ' de ',
                            ),
                            TextSpan(
                              text: controller.subjectName.value,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(
                              text: ' pour voir si vous pouvez le réussir',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- BOUTON D'ACTION (BAS) ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.startTest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ctaColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "PASSER LE TEST",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        )),
      ),
    );
  }
}

// --- WIDGET POUR RECRÉER L'ILLUSTRATION FLÈCHE ---
class _IllustrationFleche extends StatelessWidget {
  const _IllustrationFleche();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Quelques cercles décoratifs (les "bulles")
          _buildDot(top: 20, left: 30, size: 8, color: Colors.blue[200]!),
          _buildDot(top: 10, right: 40, size: 12, color: Colors.blue[400]!),
          _buildDot(bottom: 30, left: 20, size: 15, color: Colors.blue[600]!),
          _buildDot(bottom: 10, right: 30, size: 6, color: Colors.blue[300]!),
          _buildDot(top: 60, left: 10, size: 10, color: Colors.blue[100]!),
          
          // La grosse flèche centrale
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 80,
              color: Color(0xFF64B5F6),
            ),
          ),
          
          // Simulation du contour "double trait"
          Positioned(
            left: 55,
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 80,
              color: const Color(0xFF1976D2).withOpacity(0.5),
            ),
          ),
          
          // Ré-affichage de la flèche principale
          const Icon(
            Icons.arrow_forward_rounded, 
            size: 80,
            color: Color(0xFF42A5F5),
          ),
        ],
      ),
    );
  }

  Widget _buildDot({
    double? top, 
    double? bottom, 
    double? left, 
    double? right, 
    required double size, 
    required Color color
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
