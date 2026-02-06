import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/quiz_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/quiz_provider.dart';
import 'package:scai_tutor_mobile/app/data/providers/ai_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';

class QuizDetailController extends GetxController {
  final QuizProvider _quizProvider = Get.find<QuizProvider>();
  final AiProvider _aiProvider = Get.find<AiProvider>();
  final UserService _userService = Get.find<UserService>();

  final Rxn<QuizModel> quiz = Rxn<QuizModel>();
  final RxMap<String, String> answers = <String, String>{}.obs; // id_question -> answer
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString error = ''.obs;
  final RxInt currentQuestionIndex = 0.obs;
  
  // AI Help
  final RxBool showAIHelp = false.obs;
  final RxString aiHelpResponse = ''.obs;
  final RxBool isLoadingAIHelp = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    
    if (args != null) {
      if (args['quiz'] != null) {
        quiz.value = args['quiz'];
        print('[QuizDetail] Loaded quiz from arguments: ${quiz.value?.titre}');
      } else if (args['quizId'] != null) {
        fetchQuizById(args['quizId']);
      }
    }
  }

  Future<void> fetchQuizById(String quizId) async {
    try {
      isLoading.value = true;
      error.value = '';

      print('[QuizDetail] Fetching quiz: $quizId');

      final response = await _quizProvider.getById(quizId);

      if (response.data != null) {
        quiz.value = QuizModel.fromJson(response.data);
        print('[QuizDetail] Loaded quiz: ${quiz.value?.titre}');
      }
    } catch (e) {
      error.value = e.toString();
      print('[QuizDetail] Error loading quiz: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger le quiz',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setAnswer(String questionId, String answer) {
    answers[questionId] = answer;
    print('[QuizDetail] Answer set for question $questionId: $answer');
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < (quiz.value?.questions?.length ?? 0) - 1) {
      currentQuestionIndex.value++;
      showAIHelp.value = false;
      aiHelpResponse.value = '';
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      showAIHelp.value = false;
      aiHelpResponse.value = '';
    }
  }

  void goToQuestion(int index) {
    currentQuestionIndex.value = index;
    showAIHelp.value = false;
    aiHelpResponse.value = '';
  }

  Future<void> getAIHelp() async {
    if (quiz.value == null || quiz.value!.questions == null || quiz.value!.questions!.isEmpty) {
      return;
    }

    final currentQuestion = quiz.value!.questions![currentQuestionIndex.value];

    try {
      isLoadingAIHelp.value = true;
      aiHelpResponse.value = '';
      showAIHelp.value = true;

      print('[QuizDetail] Requesting AI help for question: ${currentQuestion.question}');

      // Créer un prompt pour l'IA
      final prompt = '''Je suis en train de répondre à cette question de quiz:

Question: ${currentQuestion.question}

${currentQuestion.options != null && currentQuestion.options!.isNotEmpty ? 
'Options:\n${currentQuestion.options!.asMap().entries.map((e) => '${String.fromCharCode(65 + e.key)}. ${e.value}').join('\n')}' : ''}

Peux-tu m'aider à comprendre cette question et me donner des indices pour trouver la réponse ? Ne donne pas directement la réponse, mais guide-moi dans ma réflexion.''';

      final response = await _aiProvider.ask(
        text: prompt,
        temperature: 0.7,
      );

      if (response.data != null) {
        aiHelpResponse.value = response.data['response'] ?? 
                               response.data['message'] ?? 
                               response.data['answer'] ?? 
                               'Aide non disponible';
        
        print('[QuizDetail] AI Help received');
      }
    } catch (e) {
      print('[QuizDetail] Error getting AI help: $e');
      Get.snackbar(
        'Erreur',
        'Impossible d\'obtenir l\'aide de l\'IA',
        snackPosition: SnackPosition.BOTTOM,
      );
      showAIHelp.value = false;
    } finally {
      isLoadingAIHelp.value = false;
    }
  }

  void toggleAIHelp() {
    if (showAIHelp.value) {
      showAIHelp.value = false;
      aiHelpResponse.value = '';
    } else {
      getAIHelp();
    }
  }

  Future<void> submitQuiz() async {
    if (quiz.value == null) return;

    // Vérifier si toutes les questions ont été répondues
    final totalQuestions = quiz.value!.questions?.length ?? 0;
    final answeredQuestions = answers.length;

    if (answeredQuestions < totalQuestions) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
            'Vous avez répondu à $answeredQuestions question(s) sur $totalQuestions.\n\nVoulez-vous vraiment soumettre le quiz ?'
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF228A25),
              ),
              child: const Text('Soumettre'),
            ),
          ],
        ),
      );

      if (result != true) return;
    }

    try {
      isSubmitting.value = true;

      final userId = _userService.user?.id;
      if (userId == null) {
        Get.snackbar(
          'Erreur',
          'Utilisateur non connecté',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final submissionData = {
        'id_apprenant': userId,
        'reponses': answers,
        'date_submission': DateTime.now().toIso8601String(),
      };

      print('[QuizDetail] Submitting quiz with ${answers.length} answers');

      await _quizProvider.submitQuiz(quiz.value!.id!, submissionData);

      Get.snackbar(
        'Succès',
        'Quiz soumis avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF228A25),
        colorText: Colors.white,
      );

      Get.back(result: true);
    } catch (e) {
      print('[QuizDetail] Error submitting quiz: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de soumettre le quiz',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
