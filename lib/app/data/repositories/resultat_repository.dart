import 'package:get/get.dart';
import '../models/resultat_model.dart';
import '../providers/resultat_provider.dart';
import '../providers/api_provider.dart';

class ResultatRepository {
  final ResultatProvider _resultatProvider;

  ResultatRepository()
      : _resultatProvider = ResultatProvider(Get.find<ApiProvider>());

  Future<List<ResultatModel>> getAll({Map<String, dynamic>? params}) async {
    try {
      final response = await _resultatProvider.getAll(params: params);

      if (response.statusCode == 200) {
        dynamic dataSource = response.data;
        
        // Check if data is wrapped in a 'data' key
        if (dataSource is Map && dataSource.containsKey('data')) {
          dataSource = dataSource['data'];
        }
        
        // Handle List response
        if (dataSource is List) {
          return dataSource.map((json) => ResultatModel.fromJson(json)).toList();
        } else if (dataSource is String && dataSource.isEmpty) {
          return [];
        }
        
        return [];
      } else {
        throw ApiException(
          message: 'Erreur lors de la récupération des résultats',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ResultatModel> getById(String id) async {
    try {
      final response = await _resultatProvider.getById(id);

      if (response.statusCode == 200) {
        return ResultatModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Résultat introuvable',
          statusCode: response.statusCode ?? 404,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Démarrer une évaluation
  Future<ResultatModel> demarrerEvaluation({
    required String idApprenant,
    required String idEvaluation,
  }) async {
    try {
      final response = await _resultatProvider.create({
        'id_apprenant': idApprenant,
        'id_evaluation': idEvaluation,
        'date_ouverture': DateTime.now().toIso8601String(),
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ResultatModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Erreur lors du démarrage de l\'évaluation',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Soumettre une évaluation
  Future<ResultatModel> soumettreEvaluation({
    required String id,
    required int tempsPasse,
    double? note,
    int? rang,
    String? appreciation,
  }) async {
    try {
      final response = await _resultatProvider.update(id, {
        'date_soumission': DateTime.now().toIso8601String(),
        'temps_passe': tempsPasse,
        if (note != null) 'note': note,
        if (rang != null) 'rang': rang,
        if (appreciation != null) 'appreciation': appreciation,
      });

      if (response.statusCode == 200) {
        return ResultatModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Erreur lors de la soumission de l\'évaluation',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await _resultatProvider.delete(id);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Erreur lors de la suppression du résultat',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getClassement(String idEvaluation) async {
    try {
      final response = await _resultatProvider.getClassement(idEvaluation);

      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      } else {
        throw ApiException(
          message: 'Erreur lors de la récupération du classement',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
