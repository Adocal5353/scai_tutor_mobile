import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'general_evaluation_controller.dart';

class GeneralEvaluationView extends GetView<GeneralEvaluationController> {
  const GeneralEvaluationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- 1. ARRIÈRE-PLAN (Formes abstraites) ---
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundWavePainter(),
            ),
          ),

          // --- 2. CONTENU ---
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bouton Retour
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    onPressed: controller.goBack,
                  ),
                  
                  const SizedBox(height: 20),

                  // Titre avec soulignement personnalisé
                  const Text(
                    "Evaluation Générale",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Le petit trait sous le titre
                  Container(
                    width: 60,
                    height: 3,
                    color: Colors.blue[100],
                  ),

                  const SizedBox(height: 60),

                  // Texte de description
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Les évaluations générales regroupent l'ensemble des trois matières enseignées sur la plateforme d'apprentissage",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        height: 1.4,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bouton COMMENCER
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value 
                        ? null 
                        : controller.startGeneralEvaluation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        disabledBackgroundColor: Colors.grey[400],
                      ),
                      child: controller.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "COMMENCER",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                    ),
                  )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- WIDGET POUR DESSINER LA VAGUE EN ARRIÈRE-PLAN ---
class _BackgroundWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE1F5FE)
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Début du tracé (Coin supérieur gauche - un peu en bas)
    path.moveTo(0, size.height * 0.4);

    // Courbe de Bézier pour faire la vague
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.30,
      size.width * 0.5,
      size.height * 0.4,
    );

    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.55,
      size.width,
      size.height * 0.45,
    );

    // Fermer le chemin vers le haut pour remplir
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
