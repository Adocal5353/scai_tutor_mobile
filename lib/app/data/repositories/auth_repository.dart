import 'package:get/get.dart';
import '../models/auth_response_model.dart';
import '../providers/auth_provider.dart';
import '../providers/api_provider.dart';

class AuthRepository {
  final AuthProvider _authProvider;

  AuthRepository() : _authProvider = AuthProvider(Get.find<ApiProvider>());

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authProvider.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw ApiException(
          message: response.data['message'] ?? 'Erreur de connexion',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _authProvider.logout();
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _authProvider.me();

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ApiException(
          message: 'Impossible de récupérer les informations utilisateur',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserInfo() async {
    try {
      final response = await _authProvider.user();

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ApiException(
          message: 'Impossible de récupérer les informations utilisateur',
          statusCode: response.statusCode ?? 500,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
