import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/Classe.dart';

class Classcard extends StatelessWidget {
  final Classe classe;
  final Color color;
  final IconData icon;

  Classcard({
    super.key,
    required this.classe,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/class-student-details', arguments: classe);
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Cercle coloré avec icône
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),

              // Détails de la classe
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classe.subject,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        children: [
                          TextSpan(text: '${classe.level}   '),
                          TextSpan(
                            text: classe.teacher.name ?? 'Enseignant',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bouton d'entrée
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
