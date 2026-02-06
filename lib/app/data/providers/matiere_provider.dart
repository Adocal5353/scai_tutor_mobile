import 'package:dio/dio.dart';
import 'api_provider.dart';

class MatiereProvider {
  final ApiProvider _apiProvider;

  MatiereProvider(this._apiProvider);

  // GET /api/matieres
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/matieres', queryParameters: params);
  }

  // GET /api/matieres/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/matieres/$id');
  }

  // POST /api/matieres
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/matieres', data: data);
  }

  // PUT /api/matieres/{id}
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/matieres/$id', data: data);
  }

  // DELETE /api/matieres/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/matieres/$id');
  }
}
