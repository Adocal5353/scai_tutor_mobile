import 'package:dio/dio.dart';
import 'api_provider.dart';

class AiProvider {
  final ApiProvider _apiProvider;

  AiProvider(this._apiProvider);

  // POST /api/ai/ask
  // Envoie une question a l'IA avec support d'image
  Future<Response> ask({
    required String text,
    double? temperature,
    dynamic image,
    String? imageUrl,
  }) async {
    final formData = FormData.fromMap({
      'text': text,
      if (temperature != null) 'temperature': temperature,
      if (imageUrl != null) 'image_url': imageUrl,
      if (image != null)
        'image': image is MultipartFile
            ? image
            : await MultipartFile.fromFile(image.path, filename: 'image.jpg'),
    });

    return await _apiProvider.post(
      '/ai/ask',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  // POST /api/ai/generate-quiz
  // Génère un quiz automatiquement avec l'IA
  Future<Response> generateQuiz({
    required String matiere,
    required String chapitres,
    required int nombreQuestions,
    String? niveauDifficulte,
  }) async {
    return await _apiProvider.post(
      '/ai/generate-quiz',
      data: {
        'matiere': matiere,
        'chapitres': chapitres,
        'nombre_questions': nombreQuestions,
        if (niveauDifficulte != null) 'niveau': niveauDifficulte,
      },
    );
  }
}
