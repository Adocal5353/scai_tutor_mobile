import 'package:dio/dio.dart';
import 'api_provider.dart';

class ApprenantProvider {
  final ApiProvider _apiProvider;

  ApprenantProvider(this._apiProvider);

  // GET /api/apprenants
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/apprenants', queryParameters: params);
  }

  // GET /api/apprenants/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/apprenants/$id');
  }

  // POST /api/apprenants
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/apprenants', data: data);
  }

  // PUT /api/apprenants/{id}
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/apprenants/$id', data: data);
  }

  // DELETE /api/apprenants/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/apprenants/$id');
  }
}
