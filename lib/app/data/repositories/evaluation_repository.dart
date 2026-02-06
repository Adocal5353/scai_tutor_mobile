import 'package:get/get.dart';
import '../models/evaluation_model.dart';
import '../providers/evaluation_provider.dart';
import '../providers/api_provider.dart';

class EvaluationRepository {
  final EvaluationProvider _evaluationProvider;

  EvaluationRepository()
      : _evaluationProvider = EvaluationProvider(Get.find<ApiProvider>());

  Future<List<EvaluationModel>> getAll({Map<String, dynamic>? params}) async {
    try {
      final response = await _evaluationProvider.getAll(params: params);

      if (response.statusCode == 200) {
        dynamic dataSource = response.data;
        
        // Check if data is wrapped in a 'data' key
        if (dataSource is Map && dataSource.containsKey('data')) {
          dataSource = dataSource['data'];
        }
        
        // Handle List response
        if (dataSource is List) {
          return dataSource.map((json) => EvaluationModel.fromJson(json)).toList();
        } else if (dataSource is String && dataSource.isEmpty) {
          return [];
        }
        
        return [];
      } else {
        throw ApiException(
          message: 'Erreur lors de la récupération des évaluations',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<EvaluationModel> getById(String id) async {
    try {
      final response = await _evaluationProvider.getById(id);

      if (response.statusCode == 200) {
        return EvaluationModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Évaluation introuvable',
          statusCode: response.statusCode ?? 404,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<EvaluationModel> create(EvaluationModel evaluation) async {
    try {
      final response = await _evaluationProvider.create(evaluation.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        return EvaluationModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Erreur lors de la création de l\'évaluation',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<EvaluationModel> update(String id, EvaluationModel evaluation) async {
    try {
      final response =
          await _evaluationProvider.update(id, evaluation.toJson());

      if (response.statusCode == 200) {
        return EvaluationModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Erreur lors de la mise à jour de l\'évaluation',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await _evaluationProvider.delete(id);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Erreur lors de la suppression de l\'évaluation',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
