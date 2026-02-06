import 'package:dio/dio.dart';
import 'api_provider.dart';

class DocumentProvider {
  final ApiProvider _apiProvider;

  DocumentProvider(this._apiProvider);

  // GET /api/documents
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/documents', queryParameters: params);
  }

  // GET /api/documents/{id}
  Future<Response> getById(String id) async {
    return await _apiProvider.get('/documents/$id');
  }

  // POST /api/documents - Support JSON et FormData
  Future<Response> create(dynamic data) async {
    // Si data est FormData, définir le content type approprié
    if (data is FormData) {
      return await _apiProvider.post(
        '/documents',
        data: data,
        options: Options(contentType: 'multipart/form-data'),
      );
    }
    // Sinon utiliser JSON classique
    return await _apiProvider.post('/documents', data: data);
  }

  // PUT /api/documents/{id}
  Future<Response> update(String id, Map<String, dynamic> data) async {
    return await _apiProvider.put('/documents/$id', data: data);
  }

  // DELETE /api/documents/{id}
  Future<Response> delete(String id) async {
    return await _apiProvider.delete('/documents/$id');
  }
}
