import 'package:get/get.dart';
import '../providers/enseignant_provider.dart';
import '../providers/api_provider.dart';
import '../models/enseignant_model.dart';

class EnseignantRepository {
  final EnseignantProvider _enseignantProvider;

  EnseignantRepository() : _enseignantProvider = EnseignantProvider(Get.find<ApiProvider>());

  Future<Map<String, dynamic>> create({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? telephone,
    String? specialite,
    String? etablissement,
  }) async {
    try {
      // Si prenom est vide, utiliser nom pour les deux
      final prenomFinal = prenom.isNotEmpty ? prenom : nom;
      final nomFinal = nom;
      
      final data = {
        'name': prenomFinal.isNotEmpty ? '$prenomFinal $nomFinal' : nomFinal,
        'nom': nomFinal,
        'prenom': prenomFinal,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      };

      if (telephone != null) data['telephone'] = telephone;
      if (specialite != null) data['specialite'] = specialite;
      if (etablissement != null) data['etablissement'] = etablissement;

      final response = await _enseignantProvider.create(data);

      // Gérer les réponses de succès (200, 201, 204)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else if (response.statusCode == 204) {
        // 204 No Content - L'inscription a réussi mais l'API ne retourne pas de données
        // Retourner les données envoyées comme confirmation
        return {
          'nom': nomFinal,
          'prenom': prenomFinal,
          'email': email,
          'telephone': telephone,
          'specialite': specialite,
          'etablissement': etablissement,
        };
      } else {
        throw ApiException(
          message: response.data != null && response.data is Map 
            ? (response.data['message'] ?? 'Erreur lors de la création du compte')
            : 'Erreur lors de la création du compte',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<EnseignantModel> getById(String id) async {
    try {
      final response = await _enseignantProvider.getById(id);
      
      if (response.statusCode == 200) {
        return EnseignantModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Impossible de récupérer les informations',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}
