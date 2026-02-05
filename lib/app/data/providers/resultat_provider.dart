import 'package:dio/dio.dart';
import 'api_provider.dart';

class ResultatProvider {
  final ApiProvider _apiProvider;

  ResultatProvider(this._apiProvider);

  // GET /api/resultats
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/resultats', queryParameters: params);
  }

  // GET /api/resultats/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/resultats/$id');
  }

  // POST /api/resultats (Démarrer une évaluation)
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/resultats', data: data);
  }

  // PUT /api/resultats/{id} (Soumettre une évaluation)
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/resultats/$id', data: data);
  }

  // DELETE /api/resultats/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/resultats/$id');
  }

  // GET /api/resultats/classement/{id_evaluation}
  Future<Response> getClassement(String idEvaluation) async {
    return await _apiProvider.get('/resultats/classement/$idEvaluation');
  }
}
