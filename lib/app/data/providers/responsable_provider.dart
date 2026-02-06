import 'package:dio/dio.dart';
import 'api_provider.dart';

/// Provider pour la gestion des responsables

class ResponsableProvider {
  final ApiProvider _apiProvider;

  ResponsableProvider(this._apiProvider);

  // GET /api/responsables
  //Endpoint non supporté actuellement 
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/responsables', queryParameters: params);
  }

  // GET /api/responsables/{id}
  //Endpoint non supporté actuellement
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/responsables/$id');
  }

  // POST /api/responsables
  //Crée un nouveau responsable
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/responsables', data: data);
  }

  // PUT /api/responsables/{id}
  //Endpoint non supporté actuellement
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/responsables/$id', data: data);
  }

  // DELETE /api/responsables/{id}
  //Endpoint non supporté actuellement
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/responsables/$id');
  }
}
