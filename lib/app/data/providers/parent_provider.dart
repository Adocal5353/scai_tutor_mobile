import 'package:dio/dio.dart';
import 'api_provider.dart';

class ParentProvider {
  final ApiProvider _apiProvider;

  ParentProvider(this._apiProvider);

  // GET /api/parents
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/parents', queryParameters: params);
  }

  // GET /api/parents/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/parents/$id');
  }

  // POST /api/parents
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/parents', data: data);
  }

  // PUT /api/parents/{id}
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/parents/$id', data: data);
  }

  // DELETE /api/parents/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/parents/$id');
  }
}
