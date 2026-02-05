import 'package:get/get.dart';
import '../providers/invitation_provider.dart';
import '../providers/api_provider.dart';

class InvitationRepository {
  final InvitationProvider _invitationProvider;

  InvitationRepository()
      : _invitationProvider = InvitationProvider(Get.find<ApiProvider>());

  Future<void> inviterApprenant({
    required String nom,
    required String prenom,
    required String email,
    required String idParent,
  }) async {
    try {
      final response = await _invitationProvider.inviterApprenant({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'id_parent': idParent,
      });

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ApiException(
          message: 'Erreur lors de l\'invitation de l\'apprenant',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> inviterResponsable({
    required String nom,
    required String prenom,
    required String email,
    required String idParent,
  }) async {
    try {
      final response = await _invitationProvider.inviterResponsable({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'id_parent': idParent,
      });

      if (response.statusCode != 200 &&
          response.statusCode != 201 &&
          response.statusCode != 204) {
        throw ApiException(
          message: 'Erreur lors de l\'invitation du responsable',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getAll() async {
    try {
      final response = await _invitationProvider.getAll();

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ApiException(
          message: 'Erreur lors de la récupération des invitations',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
