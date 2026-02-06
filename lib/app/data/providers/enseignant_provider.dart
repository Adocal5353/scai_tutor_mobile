import 'package:dio/dio.dart';
import 'api_provider.dart';

class EnseignantProvider {
  final ApiProvider _apiProvider;

  EnseignantProvider(this._apiProvider);

  // GET /api/enseignants
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/enseignants', queryParameters: params);
  }

  // GET /api/enseignants/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/enseignants/$id');
  }

  // POST /api/enseignants
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/enseignants', data: data);
  }

  // PUT /api/enseignants/{id}
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/enseignants/$id', data: data);
  }

  // DELETE /api/enseignants/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/enseignants/$id');
  }
}
