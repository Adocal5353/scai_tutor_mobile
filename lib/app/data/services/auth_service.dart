import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../repositories/auth_repository.dart';
import 'user_service.dart';
import '../models/user.dart';

class AuthService extends GetxService {
  final AuthRepository _authRepository = AuthRepository();
  final UserService _userService = Get.find<UserService>();
  final GetStorage _storage = GetStorage();

  // État de connexion
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthentication();
  }

  /// Vérifier si l'utilisateur est authentifié
  void _checkAuthentication() {
    final token = _storage.read('token');
    isAuthenticated.value = token != null && _userService.isLoggedIn;
  }

  /// Connexion
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final authResponse = await _authRepository.login(
        email: email,
        password: password,
      );

      // DEBUG: Log the API response
      print('[AuthService] ========== LOGIN RESPONSE DEBUG ==========');
      print('[AuthService] Message: ${authResponse.message}');
      print('[AuthService] User Type: ${authResponse.userType}');
      print('[AuthService] Token: ${authResponse.token}');
      print('[AuthService] User Data: ${authResponse.user}');
      print('[AuthService] User _id: ${authResponse.user['_id']}');
      print('[AuthService] User id: ${authResponse.user['id']}');
      print('[AuthService] All User Keys: ${authResponse.user.keys}');
      print('[AuthService] ================================================');

      // Extract ID based on user type
      String? userId;
      if (authResponse.userType == 'apprenant') {
        userId = authResponse.user['id_apprenant']?.toString() ?? authResponse.user['user_id']?.toString();
      } else if (authResponse.userType == 'enseignant') {
        userId = authResponse.user['id_enseignant']?.toString() ?? authResponse.user['user_id']?.toString();
      } else if (authResponse.userType == 'parent') {
        userId = authResponse.user['id_parent']?.toString() ?? authResponse.user['user_id']?.toString();
      } else {
        userId = authResponse.user['user_id']?.toString() ?? authResponse.user['id']?.toString();
      }

      print('[AuthService] Extracted userId: $userId');

      // Créer l'objet User à partir de la réponse
      final user = User(
        id: userId,
        role: _mapUserTypeToRole(authResponse.userType),
        name: authResponse.user['name'] ??
            '${authResponse.user['prenom']} ${authResponse.user['nom']}',
        email: authResponse.user['email'],
        token: authResponse.token,
        imageUrl: authResponse.user['imageUrl'] ??
            'assets/images/default_avatar.png',
      );

      print('[AuthService] Created User object - ID: ${user.id}, Name: ${user.name}, Role: ${user.role}');

      // Sauvegarder l'utilisateur
      _userService.setUser(
        user,
        token: authResponse.token,
        userType: authResponse.userType,
      );

      isAuthenticated.value = true;
      isLoading.value = false;

      return true;
    } catch (e) {
      isLoading.value = false;
      print('AuthService: Erreur de connexion - $e');
      rethrow;
    }
  }

  /// Déconnexion
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Appeler l'API de déconnexion
      await _authRepository.logout();

      // Effacer les données locales
      await _userService.logout();

      isAuthenticated.value = false;
      isLoading.value = false;

      // Rediriger vers la page de connexion
      Get.offAllNamed('/login');
    } catch (e) {
      isLoading.value = false;
      print('AuthService: Erreur lors de la déconnexion - $e');

      // Forcer la déconnexion locale même en cas d'erreur API
      await _userService.logout();
      isAuthenticated.value = false;
      Get.offAllNamed('/login');
    }
  }

  /// Récupérer les informations de l'utilisateur connecté
  Future<void> refreshUserInfo() async {
    try {
      final userInfo = await _authRepository.getCurrentUser();

      final user = User(
        id: userInfo['_id'] ?? userInfo['id'],
        role: _userService.userRole ?? 'learner',
        name: userInfo['name'] ??
            '${userInfo['prenom']} ${userInfo['nom']}',
        email: userInfo['email'],
        token: _userService.token,
        imageUrl: userInfo['imageUrl'] ?? 'assets/images/default_avatar.png',
      );

      _userService.updateUser(user);
    } catch (e) {
      print('AuthService: Erreur lors de la récupération des infos - $e');
      rethrow;
    }
  }

  /// Mapper le type d'utilisateur de l'API au rôle local
  String _mapUserTypeToRole(String userType) {
    switch (userType) {
      case 'apprenant':
        return 'learner';
      case 'enseignant':
        return 'teacher';
      case 'parent':
        return 'parent';
      case 'responsable':
        return 'responsable';
      default:
        return 'learner';
    }
  }

  /// Vérifier si le token est valide
  bool get hasValidToken {
    final token = _storage.read('token');
    return token != null && token.isNotEmpty;
  }
}
