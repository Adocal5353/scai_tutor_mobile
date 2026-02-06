import 'package:dio/dio.dart';
import 'api_provider.dart';

class QuizProvider {
  final ApiProvider _apiProvider;

  QuizProvider(this._apiProvider);

  // GET /api/quizzes - Récupérer tous les quiz
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/quizzes', queryParameters: params);
  }

  // GET /api/quizzes/{id} - Récupérer un quiz par ID
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/quizzes/$id');
  }

  // POST /api/quizzes - Créer un quiz
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/quizzes', data: data);
  }

  // POST /api/quizzes/generate - Générer un quiz avec l'IA
  Future<Response> generateWithAI(Map<String, dynamic> data) async {
    return await _apiProvider.post('/quizzes/generate', data: data);
  }

  // PUT /api/quizzes/{id} - Mettre à jour un quiz
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/quizzes/$id', data: data);
  }

  // DELETE /api/quizzes/{id} - Supprimer un quiz
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/quizzes/$id');
  }

  // GET /api/quizzes/classe/{id_classe} - Quiz d'une classe
  Future<Response> getByClasse(String idClasse) async {
    return await _apiProvider.get('/quizzes/classe/$idClasse');
  }

  // GET /api/quizzes/apprenant/{id_apprenant} - Quiz d'un étudiant
  Future<Response> getByApprenant(String idApprenant) async {
    return await _apiProvider.get('/quizzes/apprenant/$idApprenant');
  }

  // POST /api/quizzes/{id}/submit - Soumettre un quiz
  Future<Response> submitQuiz(String idQuiz, Map<String, dynamic> data) async {
    return await _apiProvider.post('/quizzes/$idQuiz/submit', data: data);
  }

  // GET /api/quizzes/{id}/submissions - Récupérer les soumissions d'un quiz
  Future<Response> getSubmissions(String idQuiz) async {
    return await _apiProvider.get('/quizzes/$idQuiz/submissions');
  }

  // POST /api/quizzes/{id}/assign - Assigner un quiz à une classe
  Future<Response> assignToClasse(String idQuiz, String idClasse) async {
    return await _apiProvider.post('/quizzes/$idQuiz/assign', data: {
      'id_classe': idClasse,
    });
  }
}
