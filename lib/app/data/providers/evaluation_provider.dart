import 'package:dio/dio.dart';
import 'api_provider.dart';

class EvaluationProvider {
  final ApiProvider _apiProvider;

  EvaluationProvider(this._apiProvider);

  // GET /api/evaluations
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/evaluations', queryParameters: params);
  }

  // GET /api/evaluations/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/evaluations/$id');
  }

  // POST /api/evaluations
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/evaluations', data: data);
  }

  // PUT /api/evaluations/{id}
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/evaluations/$id', data: data);
  }

  // DELETE /api/evaluations/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/evaluations/$id');
  }
}
