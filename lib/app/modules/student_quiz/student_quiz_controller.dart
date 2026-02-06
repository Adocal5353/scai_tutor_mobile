import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/quiz_model.dart';
import 'package:scai_tutor_mobile/app/data/providers/quiz_provider.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class StudentQuizController extends GetxController {
  final QuizProvider _quizProvider = Get.find<QuizProvider>();
  final UserService _userService = Get.find<UserService>();

  final RxList<QuizModel> quizzes = <QuizModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString selectedFilter = 'all'.obs; // all, pending, completed

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
  }

  Future<void> fetchQuizzes() async {
    try {
      isLoading.value = true;
      error.value = '';

      final userId = _userService.user?.id;
      if (userId == null) {
        error.value = 'Utilisateur non connecté';
        return;
      }

      print('[StudentQuiz] Fetching quizzes for student: $userId');

      final response = await _quizProvider.getByApprenant(userId.toString());

      if (response.data != null) {
        final List<dynamic> data = response.data is List 
          ? response.data 
          : (response.data['data'] ?? response.data['quizzes'] ?? []);
        
        quizzes.value = data
          .map((json) => QuizModel.fromJson(json as Map<String, dynamic>))
          .toList();

        print('[StudentQuiz] Loaded ${quizzes.length} quizzes');
      }
    } catch (e) {
      error.value = e.toString();
      print('[StudentQuiz] Error loading quizzes: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de charger les quiz',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<QuizModel> get filteredQuizzes {
    if (selectedFilter.value == 'all') {
      return quizzes;
    } else if (selectedFilter.value == 'pending') {
      // Quiz non complétés (logique à adapter selon votre backend)
      return quizzes.where((q) => q.dateLimite != null && q.dateLimite!.isAfter(DateTime.now())).toList();
    } else {
      // Quiz complétés
      return quizzes.where((q) => q.dateLimite != null && q.dateLimite!.isBefore(DateTime.now())).toList();
    }
  }

  void goToQuizDetail(QuizModel quiz) {
    Get.toNamed(
      Routes.QUIZ_DETAIL,
      arguments: {
        'quizId': quiz.id,
        'quiz': quiz,
      },
    );
  }

  void goBack() {
    Get.back();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }
}
