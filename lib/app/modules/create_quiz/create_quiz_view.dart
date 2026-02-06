import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'package:intl/intl.dart';

import 'create_quiz_controller.dart';

class CreateQuizView extends GetView<CreateQuizController> {
  const CreateQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),
      appBar: AppBar(
        backgroundColor: SC_ThemeColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: controller.goBack,
        ),
        title: const Text(
          'Créer un Quiz Pratique',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoadingMatieres.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Option génération IA
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: SC_ThemeColors.darkBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: SC_ThemeColors.darkBlue,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Générer avec l\'IA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Obx(() => Switch(
                            value: controller.useAI.value,
                            onChanged: (value) {
                              controller.useAI.value = value;
                              if (!value) {
                                controller.generatedQuestions.clear();
                              }
                            },
                            activeColor: SC_ThemeColors.darkBlue,
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Titre
                    const Text(
                      'Titre du Quiz',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.titreController,
                      decoration: InputDecoration(
                        hintText: 'Ex: Quiz de Mathématiques - Chapitre 1',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Matière
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Matière',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          onPressed: () => controller.showCreateMatiereDialog(context),
                          icon: const Icon(Icons.add_circle, color: Color(0xFF228A25)),
                          tooltip: 'Ajouter une matière',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: controller.matieres.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Aucune matière disponible',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => controller.showCreateMatiereDialog(context),
                                      icon: const Icon(Icons.add, size: 18),
                                      label: const Text('Créer'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Color(0xFF228A25),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: controller.selectedMatiere.value?.id,
                                  hint: const Text('Sélectionnez une matière'),
                                  items: controller.matieres.map((matiere) {
                                    return DropdownMenuItem<String>(
                                      value: matiere.id,
                                      child: Text(matiere.nomMatiere),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      controller.selectedMatiere.value =
                                          controller.matieres.firstWhere(
                                        (m) => m.id == value,
                                      );
                                    }
                                  },
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Chapitres concernés
                    const Text(
                      'Chapitres Concernés',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.chapitresController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Ex: Chapitre 1, Chapitre 2, Chapitre 3',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Options IA (si activée)
                    Obx(() => controller.useAI.value
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nombre de questions
                              const Text(
                                'Nombre de Questions',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: controller.nombreQuestionsController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '10',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Niveau de difficulté
                              const Text(
                                'Niveau de Difficulté',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Obx(() => DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: controller.selectedDifficulty.value,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'facile',
                                        child: Text('Facile'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'moyen',
                                        child: Text('Moyen'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'difficile',
                                        child: Text('Difficile'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.selectedDifficulty.value = value;
                                      }
                                    },
                                  ),
                                )),
                              ),
                              const SizedBox(height: 16),

                              // Bouton générer avec IA
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.generateQuizWithAI,
                                  icon: const Icon(Icons.auto_awesome),
                                  label: const Text('Générer les Questions'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: SC_ThemeColors.darkBlue,
                                    disabledBackgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),

                              // Afficher les questions générées
                              Obx(() => controller.generatedQuestions.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: SC_ThemeColors.lightBlue,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.check_circle, color: Colors.green),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  '${controller.generatedQuestions.length} questions générées avec succès',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink()),
                              const SizedBox(height: 20),
                            ],
                          )
                        : const SizedBox.shrink()),

                    // Date limite
                    const Text(
                      'Date Limite de Soumission',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => controller.selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Obx(
                                () => Text(
                                  controller.selectedDate.value != null
                                      ? DateFormat('dd/MM/yyyy à HH:mm')
                                          .format(controller.selectedDate.value!)
                                      : 'Sélectionnez une date et heure',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: controller.selectedDate.value != null
                                        ? Colors.black87
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Bouton Créer
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.createQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SC_ThemeColors.normalGreen,
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Créer le Quiz',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
