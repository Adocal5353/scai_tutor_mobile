import 'package:dio/dio.dart';
import 'api_provider.dart';

class DemandeInscriptionProvider {
  final ApiProvider _apiProvider;

  DemandeInscriptionProvider(this._apiProvider);

  // GET /api/demandes-inscription
  Future<Response> getAll({Map<String, dynamic>? params}) async {
    return await _apiProvider.get('/demandes-inscription', queryParameters: params);
  }

  // POST /api/demandes-inscription
  Future<Response> create(Map<String, dynamic> data) async {
    return await _apiProvider.post('/demandes-inscription', data: data);
  }

  // POST /api/demandes-inscription/{id}/accepter
  Future<Response> accepter(String id) async {
    return await _apiProvider.post('/demandes-inscription/$id/accepter');
  }

  // POST /api/demandes-inscription/{id}/refuser
  Future<Response> refuser(String id, {String? motif}) async {
    return await _apiProvider.post(
      '/demandes-inscription/$id/refuser',
      data: motif != null ? {'motif_refus': motif} : null,
    );
  }
}
