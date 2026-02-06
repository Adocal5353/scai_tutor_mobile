import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';

import 'quiz_detail_controller.dart';

class QuizDetailView extends GetView<QuizDetailController> {
  const QuizDetailView({super.key});

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
        title: Obx(() => Text(
          controller.quiz.value?.titre ?? 'Quiz',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )),
        centerTitle: true,
        actions: [
          // Bouton aide IA
          Obx(() => IconButton(
            icon: Icon(
              controller.showAIHelp.value ? Icons.close : Icons.help_outline,
              color: Colors.white,
            ),
            onPressed: controller.toggleAIHelp,
            tooltip: 'Aide IA',
          )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.quiz.value == null) {
          return const Center(
            child: Text('Quiz non trouvé'),
          );
        }

        final quiz = controller.quiz.value!;
        final questions = quiz.questions ?? [];

        if (questions.isEmpty) {
          return const Center(
            child: Text('Aucune question disponible'),
          );
        }

        return Column(
          children: [
            // Progress bar
            _buildProgressBar(questions.length),

            // AI Help section
            Obx(() => controller.showAIHelp.value
                ? _buildAIHelpSection()
                : const SizedBox.shrink()),

            // Question
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _buildQuestionCard(questions[controller.currentQuestionIndex.value]),
              ),
            ),

            // Navigation buttons
            _buildNavigationButtons(questions.length),
          ],
        );
      }),
    );
  }

  Widget _buildProgressBar(int totalQuestions) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                'Question ${controller.currentQuestionIndex.value + 1}/$totalQuestions',
                style:const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )),
              Obx(() => Text(
                '${controller.answers.length}/$totalQuestions répondues',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() => LinearProgressIndicator(
            value: (controller.currentQuestionIndex.value + 1) / totalQuestions,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(SC_ThemeColors.darkBlue),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          )),
        ],
      ),
    );
  }

  Widget _buildAIHelpSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SC_ThemeColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: SC_ThemeColors.darkBlue.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: SC_ThemeColors.darkBlue,
              ),
              const SizedBox(width: 8),
              const Text(
                'Aide de l\'IA',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isLoadingAIHelp.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (controller.aiHelpResponse.value.isEmpty) {
              return const Text('Chargement de l\'aide...');
            }

            return Text(
              controller.aiHelpResponse.value,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(dynamic question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SC_ThemeColors.lightBlue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              question.question ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Options (si QCM)
          if (question.options != null && question.options.isNotEmpty)
            ...question.options.asMap().entries.map((entry) {
              final int index = entry.key;
              final option = entry.value;
              final optionLetter = String.fromCharCode(65 + index); // A, B, C, D...

              return Obx(() {
                final isSelected = controller.answers[question.id] == option;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? SC_ThemeColors.darkBlue
                          : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: isSelected
                        ? SC_ThemeColors.darkBlue.withOpacity(0.05)
                        : Colors.transparent,
                  ),
                  child: RadioListTile<String>(
                    value: option,
                    groupValue: controller.answers[question.id],
                    onChanged: (value) {
                      if (value != null) {
                        controller.setAnswer(question.id, value);
                      }
                    },
                    title: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? SC_ThemeColors.darkBlue
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            optionLetter,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? SC_ThemeColors.darkBlue : Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    activeColor: SC_ThemeColors.darkBlue,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                );
              });
            }).toList()
          else
            // Réponse libre
            Obx(() => TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tapez votre réponse ici...',
                filled: true,
                fillColor: const Color(0xFFF2F5F8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              onChanged: (value) {
                controller.setAnswer(question.id, value);
              },
              controller: TextEditingController(
                text: controller.answers[question.id] ?? '',
              ),
            )),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(int totalQuestions) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Bouton Précédent
          Obx(() => controller.currentQuestionIndex.value > 0
              ? Expanded(
                  child: OutlinedButton(
                    onPressed: controller.previousQuestion,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: SC_ThemeColors.darkBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'Précédent',
                      style: TextStyle(
                        color: SC_ThemeColors.darkBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),

          Obx(() => controller.currentQuestionIndex.value > 0
              ? const SizedBox(width: 12)
              : const SizedBox.shrink()),

          // Bouton Suivant ou Soumettre
          Expanded(
            child: Obx(() {
              final isLastQuestion =
                  controller.currentQuestionIndex.value == totalQuestions - 1;

              return ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : (isLastQuestion
                        ? controller.submitQuiz
                        : controller.nextQuestion),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastQuestion
                      ? SC_ThemeColors.normalGreen
                      : SC_ThemeColors.darkBlue,
                  disabledBackgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        isLastQuestion ? 'Soumettre le Quiz' : 'Suivant',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
