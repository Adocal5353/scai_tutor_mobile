import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/user.dart';

/// Service global pour gérer l'état de l'utilisateur connecté
class UserService extends GetxService {
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

  /// Méthode d'initialisation du service
  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  /// Charger l'utilisateur depuis le stockage local
  /// TODO: Implémenter avec GetStorage
  Future<void> _loadUserFromStorage() async {
    // Exemple avec GetStorage:
    // final storage = GetStorage();
    // final userData = storage.read('user');
    // if (userData != null) {
    //   currentUser.value = User.fromJson(userData);
    // }
    
    print('UserService: Chargement utilisateur depuis le stockage...');
  }

  /// Définir l'utilisateur connecté
  void setUser(User user) {
    currentUser.value = user;
    _saveUserToStorage(user);
    print('UserService: Utilisateur défini - ${user.name} (${user.role})');
  }

  /// Mettre à jour les informations de l'utilisateur
  void updateUser(User user) {
    currentUser.value = user;
    _saveUserToStorage(user);
    print('UserService: Utilisateur mis à jour - ${user.name}');
  }

  /// Sauvegarder l'utilisateur dans le stockage local
  /// TODO: Implémenter avec GetStorage
  Future<void> _saveUserToStorage(User user) async {
    // Exemple avec GetStorage:
    // final storage = GetStorage();
    // await storage.write('user', user.toJson());
    
    print('UserService: Sauvegarde utilisateur dans le stockage...');
  }

  /// Déconnecter l'utilisateur
  Future<void> logout() async {
    currentUser.value = null;
    await _clearUserFromStorage();
    print('UserService: Utilisateur déconnecté');
  }

  /// Effacer l'utilisateur du stockage local
  /// TODO: Implémenter avec GetStorage
  Future<void> _clearUserFromStorage() async {
    // Exemple avec GetStorage:
    // final storage = GetStorage();
    // await storage.remove('user');
    // await storage.remove('token');
    
    print('UserService: Effacement utilisateur du stockage...');
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
