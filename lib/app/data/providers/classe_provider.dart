import 'package:dio/dio.dart';
import 'api_provider.dart';

class ClasseProvider {
  final ApiProvider _apiProvider;

  ClasseProvider(this._apiProvider);

  // GET /api/classes
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/classes', queryParameters: params);
  }

  // GET /api/classes/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/classes/$id');
  }

  // POST /api/classes
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/classes', data: data);
  }

  // PUT /api/classes/{id}
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/classes/$id', data: data);
  }

  // DELETE /api/classes/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/classes/$id');
  }

  // POST /api/classes/{id}/apprenants
  // Assigne un tableau d'IDs d'apprenants à une classe
  Future<Response> assignApprenants(
    String id,
    List<String> apprenantsIds,
  ) async {
    return await _apiProvider.post(
      '/classes/$id/apprenants',
      data: {'apprenants': apprenantsIds},
    );
  }

  // GET /api/classes/{id_classe}/demandes-inscription
  Future<Response> getDemandesInscription(String idClasse) async {
    return await _apiProvider.get('/classes/$idClasse/demandes-inscription');
  }
}
