import 'package:get/get.dart';
import '../models/classe_model.dart';
import '../providers/classe_provider.dart';
import '../providers/api_provider.dart';

class ClasseRepository {
  final ClasseProvider _classeProvider;

  ClasseRepository()
      : _classeProvider = ClasseProvider(Get.find<ApiProvider>());

  Future<List<ClasseModel>> getAll({Map<String, dynamic>? params}) async {
    try {
      final response = await _classeProvider.getAll(params: params);

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? response.data;
        return data.map((json) => ClasseModel.fromJson(json)).toList();
      } else {
        throw ApiException(
          message: 'Erreur lors de la récupération des classes',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ClasseModel> getById(String id) async {
    try {
      final response = await _classeProvider.getById(id);

      if (response.statusCode == 200) {
        return ClasseModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Classe introuvable',
          statusCode: response.statusCode ?? 404,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ClasseModel> create(ClasseModel classe) async {
    try {
      final response = await _classeProvider.create(classe.toJson());

      // 200, 201: succès avec données
      // 204: succès sans contenu (No Content)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClasseModel.fromJson(response.data);
      } else if (response.statusCode == 204) {
        // Succès sans données retournées, on retourne l'objet original
        return classe;
      } else {
        throw ApiException(
          message: 'Erreur lors de la création de la classe',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ClasseModel> update(String id, ClasseModel classe) async {
    try {
      final response = await _classeProvider.update(id, classe.toJson());

      if (response.statusCode == 200) {
        return ClasseModel.fromJson(response.data);
      } else {
        throw ApiException(
          message: 'Erreur lors de la mise à jour de la classe',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await _classeProvider.delete(id);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ApiException(
          message: 'Erreur lors de la suppression de la classe',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> assignApprenants(String id, List<String> apprenantsIds) async {
    try {
      final response = await _classeProvider.assignApprenants(id, apprenantsIds);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
          message: 'Erreur lors de l\'assignation des apprenants',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<dynamic>> getDemandesInscription(String idClasse) async {
    try {
      final response = await _classeProvider.getDemandesInscription(idClasse);

      if (response.statusCode == 200) {
        return response.data['data'] ?? response.data;
      } else {
        throw ApiException(
          message: 'Erreur lors de la récupération des demandes',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
