import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'general_evaluation_controller.dart';

class GeneralEvaluationView extends GetView<GeneralEvaluationController> {
  const GeneralEvaluationView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE7EEFF),
      body: SafeArea(
        child: Stack(
          children: [
            // Background waves
            Positioned(
              top: 90,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Ellipse_image.png',
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 26),
                    onPressed: controller.goBack,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Evaluation Générale",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Les évaluations générales regroupent l'ensemble des trois matières enseignées sur la plateforme d'apprentissage",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0047CC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: controller.startEvaluation,
                      child: const Text(
                        "COMMENCER",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
