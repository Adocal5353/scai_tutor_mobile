import 'package:get/get.dart';
import '../providers/parent_provider.dart';
import '../providers/api_provider.dart';
import '../models/parent_model.dart';

class ParentRepository {
  final ParentProvider _parentProvider;

  ParentRepository() : _parentProvider = ParentProvider(Get.find<ApiProvider>());

  Future<Map<String, dynamic>> create({
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String passwordConfirmation,
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
      };

      if (telephone != null && telephone.isNotEmpty) {
        data['telephone'] = telephone;
      }

      // LOG 1: Données envoyées
      print('[ParentRepository] Création parent - Données envoyées:');
      print('   - nom: $nomFinal');
      print('   - prenom: $prenomFinal');
      print('   - email: $email');
      print('   - telephone: $telephone');
      print('   - data complet: $data');

      final response = await _parentProvider.create(data);

      // LOG 2: Réponse brute
      print('[ParentRepository] Réponse API:');
      print('   - statusCode: ${response.statusCode}');
      print('   - response.data type: ${response.data.runtimeType}');
      print('   - response.data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        // Handle 204 No Content - success with no body
        if (response.statusCode == 204 || response.data == null || response.data.toString().isEmpty) {
          print('[ParentRepository] Création parent réussie (204 No Content)');
          return {
            'id': 'created',
            'nom': nom,
            'prenom': prenom,
            'email': email,
          };
        }
        
        // LOG 3: Vérification du type de response.data
        if (response.data is! Map<String, dynamic>) {
          print('[ParentRepository] ATTENTION: response.data n\'est pas un Map<String, dynamic>');
          print('   - Type reçu: ${response.data.runtimeType}');
          
          // Tenter de convertir si c'est une Map avec d'autres types de clés
          if (response.data is Map) {
            print('   - Tentative de conversion du Map...');
            try {
              final convertedData = Map<String, dynamic>.from(response.data as Map);
              print('[ParentRepository] Conversion réussie');
              print('   - Données converties: $convertedData');
              return convertedData;
            } catch (e) {
              print('[ParentRepository] Échec de conversion: $e');
              throw ApiException(
                message: 'Erreur de conversion: ${response.data.runtimeType} -> Map<String, dynamic>',
                statusCode: response.statusCode ?? 500,
              );
            }
          }
          
          throw ApiException(
            message: 'Format de réponse invalide: ${response.data.runtimeType}',
            statusCode: response.statusCode ?? 500,
          );
        }
        
        print('[ParentRepository] Création parent réussie');
        return response.data as Map<String, dynamic>;
      } else {
        final errorMessage = response.data is Map 
          ? (response.data['message'] ?? 'Erreur lors de la création du compte')
          : 'Erreur lors de la création du compte';
        print('[ParentRepository] Erreur API: $errorMessage');
        throw ApiException(
          message: errorMessage,
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e, stackTrace) {
      print('[ParentRepository] Exception attrapée:');
      print('   - Type: ${e.runtimeType}');
      print('   - Message: $e');
      print('   - StackTrace: $stackTrace');
      rethrow;
    }
  }

  Future<ParentModel> getById(String id) async {
    try {
      final response = await _parentProvider.getById(id);
      
      if (response.statusCode == 200) {
        return ParentModel.fromJson(response.data);
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
