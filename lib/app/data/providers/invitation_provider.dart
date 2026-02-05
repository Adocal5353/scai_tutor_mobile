import 'package:dio/dio.dart';
import 'api_provider.dart';

class InvitationProvider {
  final ApiProvider _apiProvider;

  InvitationProvider(this._apiProvider);

  // POST /api/inviter-apprenant
  Future<Response> inviterApprenant(Map<String, dynamic> data) async {
    return await _apiProvider.post('/inviter-apprenant', data: data);
  }

  // POST /api/inviter-responsable
  Future<Response> inviterResponsable(Map<String, dynamic> data) async {
    return await _apiProvider.post('/inviter-responsable', data: data);
  }

  // GET /api/invitations
  Future<Response> getAll() async {
    return await _apiProvider.get('/invitations');
  }
}
