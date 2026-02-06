import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiProvider {
  late final Dio _dio;
  final GetStorage _storage = GetStorage();

  ApiProvider() {
    _dio = Dio(_dioBaseOptions);
    _setupInterceptors();
  }

  BaseOptions get _dioBaseOptions => BaseOptions(
        baseUrl: dotenv.env['BASE_URL'] ?? 'http://localhost:8000/api',
        connectTimeout: Duration(
          seconds: int.parse(dotenv.env['CONNECT_TIMEOUT'] ?? '30'),
        ),
        receiveTimeout: Duration(
          seconds: int.parse(dotenv.env['RECEIVE_TIMEOUT'] ?? '30'),
        ),
        sendTimeout: Duration(
          seconds: int.parse(dotenv.env['SEND_TIMEOUT'] ?? '30'),
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ajouter le token d'authentification si disponible
          final token = _storage.read('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Gestion automatique des erreurs 401 (Unauthorized)
          if (error.response?.statusCode == 401) {
            // Vérifier si c'est une requête vers un endpoint public (login, inscription)
            final path = error.requestOptions.path;
            final isPublicEndpoint = path.contains('/login') || 
                                     path.contains('/apprenants') || 
                                     path.contains('/enseignants') ||
                                     path.contains('/parents') ||
                                     path.contains('/register');
            
            // Ne pas rediriger si c'est une tentative de connexion/inscription
            // Dans ce cas, l'erreur 401 signifie "identifiants invalides"
            if (!isPublicEndpoint) {
              // Token expiré ou invalide
              _storage.remove('token');
              _storage.remove('user');
              _storage.remove('user_type');
              
              // Rediriger vers la page de login
              getx.Get.offAllNamed('/login');
              
              getx.Get.snackbar(
                'Session expirée',
                'Veuillez vous reconnecter',
                snackPosition: getx.SnackPosition.BOTTOM,
                duration: const Duration(seconds: 3),
              );
            }
            // Pour les endpoints publics, laisser l'erreur se propager normalement
          }
          
          // Gestion des autres erreurs
          else if (error.response?.statusCode == 404) {
            getx.Get.snackbar(
              'Erreur',
              'Ressource introuvable',
              snackPosition: getx.SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          } else if (error.response?.statusCode == 422) {
            // Erreur de validation
            final errors = error.response?.data['errors'] ?? {};
            final firstError = errors.values.first[0] ?? 'Erreur de validation';
            getx.Get.snackbar(
              'Validation échouée',
              firstError,
              snackPosition: getx.SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          } else if (error.response?.statusCode == 500) {
            // Afficher le message d'erreur réel du backend si disponible
            final errorMessage = error.response?.data['message'] ?? 
                                'Une erreur est survenue. Veuillez réessayer.';
            getx.Get.snackbar(
              'Erreur serveur',
              errorMessage,
              snackPosition: getx.SnackPosition.BOTTOM,
              duration: const Duration(seconds: 5),
            );
          }
          
          return handler.next(error);
        },
      ),
    );

    // Logger pour le debug (désactiver en production)
    if (dotenv.env['DEBUG_MODE'] == 'true') {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }

  // Méthodes HTTP
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Gestion des erreurs
  ApiException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Délai de connexion dépassé',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: error.response?.data['message'] ?? 'Erreur serveur',
          statusCode: error.response?.statusCode ?? 500,
          errors: error.response?.data['errors'],
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Requête annulée',
          statusCode: 499,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Pas de connexion internet',
          statusCode: 503,
        );
      default:
        return ApiException(
          message: 'Une erreur inattendue s\'est produite',
          statusCode: 500,
        );
    }
  }
}

// Exception personnalisée pour les erreurs API
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });

  @override
  String toString() => message;
}
