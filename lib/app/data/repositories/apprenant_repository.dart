import 'package:get/get.dart';
import '../models/apprenant_model.dart';
import '../providers/apprenant_provider.dart';
import '../providers/api_provider.dart';

class ApprenantRepository {
  final ApprenantProvider _apprenantProvider;

  ApprenantRepository()
      : _apprenantProvider = ApprenantProvider(Get.find<ApiProvider>());

  Future<List<ApprenantModel>> getAll({Map<String, dynamic>? params}) async {
    try {
      final response = await _apprenantProvider.getAll(params: params);

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? response.data;
        return data.map((json) => ApprenantModel.fromJson(json)).toList();
      } else {
        throw ApiException(
          message: 'Erreur lors de la récupération des apprenants',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ApprenantModel> getById(String id) async {
    try {
      final response = await _apprenantProvider.getById(id);

      if (response.statusCode == 200) {
        return ApprenantModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Apprenant introuvable',
          statusCode: response.statusCode ?? 404,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> create({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? niveauScolaire,
    String? telephone,
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
        'origine_creation': 'directe',
      };

      if (niveauScolaire != null) data['niveau_scolaire'] = niveauScolaire;
      if (telephone != null) data['telephone'] = telephone;

      final response = await _apprenantProvider.create(data);

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
          'niveau_scolaire': niveauScolaire,
          'telephone': telephone,
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
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException({required this.message, required this.statusCode});

  @override
  String toString() => message;
}
