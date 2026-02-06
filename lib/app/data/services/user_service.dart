import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scai_tutor_mobile/app/data/models/user.dart';

/// Service global pour gérer l'état de l'utilisateur connecté
class UserService extends GetxService {
  final GetStorage _storage = GetStorage();

  // Utilisateur actuel (observable)
  final Rx<User?> currentUser = Rx<User?>(null);

  // Getters pour faciliter l'accès
  User? get user => currentUser.value;
  bool get isLoggedIn => currentUser.value != null;
  String? get userRole => currentUser.value?.role;
  String? get userName => currentUser.value?.name;
  String? get userEmail => currentUser.value?.email;
  String? get userImageUrl => currentUser.value?.imageUrl;
  String? get userId => currentUser.value?.id;
  String? get token => _storage.read('token');
  String? get userType => _storage.read('user_type');

  /// Méthode d'initialisation du service
  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  /// Charger l'utilisateur depuis le stockage local
  Future<void> _loadUserFromStorage() async {
    try {
      final userData = _storage.read('user');
      if (userData != null) {
        currentUser.value = User.fromJson(Map<String, dynamic>.from(userData));
        print('UserService: Utilisateur chargé - ${currentUser.value?.name}');
      }
    } catch (e) {
      print('UserService: Erreur lors du chargement - $e');
    }
  }

  /// Définir l'utilisateur connecté
  void setUser(User user, {String? token, String? userType}) {
    currentUser.value = user;
    _saveUserToStorage(user, token: token, userType: userType);
    print('UserService: Utilisateur défini - ${user.name} (${user.role})');
  }

  /// Mettre à jour les informations de l'utilisateur
  void updateUser(User user) {
    currentUser.value = user;
    _storage.write('user', user.toJson());
    print('UserService: Utilisateur mis à jour - ${user.name}');
  }

  /// Sauvegarder l'utilisateur dans le stockage local
  Future<void> _saveUserToStorage(
    User user, {
    String? token,
    String? userType,
  }) async {
    try {
      await _storage.write('user', user.toJson());
      if (token != null) {
        await _storage.write('token', token);
      }
      if (userType != null) {
        await _storage.write('user_type', userType);
      }
      print('UserService: Utilisateur sauvegardé avec succès');
    } catch (e) {
      print('UserService: Erreur lors de la sauvegarde - $e');
    }
  }

  /// Déconnecter l'utilisateur
  Future<void> logout() async {
    currentUser.value = null;
    await _clearUserFromStorage();
    print('UserService: Utilisateur déconnecté');
  }

  /// Effacer l'utilisateur du stockage local
  Future<void> _clearUserFromStorage() async {
    try {
      await _storage.remove('user');
      await _storage.remove('token');
      await _storage.remove('user_type');
      print('UserService: Stockage effacé avec succès');
    } catch (e) {
      print('UserService: Erreur lors de l\'effacement - $e');
    }
  }

  /// Vérifier si l'utilisateur a un rôle spécifique
  bool hasRole(String role) {
    return currentUser.value?.role == role;
  }

  /// Vérifier si l'utilisateur est un apprenant
  bool get isLearner => hasRole('learner');

  /// Vérifier si l'utilisateur est un enseignant
  bool get isTeacher => hasRole('teacher');

  /// Vérifier si l'utilisateur est un parent
  bool get isParent => hasRole('parent');
}
