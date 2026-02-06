import 'package:dio/dio.dart';
import 'api_provider.dart';

class AuthProvider {
  final ApiProvider _apiProvider;

  AuthProvider(this._apiProvider);

  // POST /api/login
  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _apiProvider.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  // POST /api/logout
  Future<Response> logout() async {
    return await _apiProvider.post('/logout');
  }

  // GET /api/me
  Future<Response> me() async {
    return await _apiProvider.get('/me');
  }

  // GET /api/user
  Future<Response> user() async {
    return await _apiProvider.get('/user');
  }
}
