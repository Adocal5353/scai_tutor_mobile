import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/user.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/data/services/auth_service.dart';
import '../../routes/app_pages.dart';

class ProfileController extends GetxController {
  // Injection des services
  final UserService _userService = Get.find<UserService>();
  final AuthService _authService = Get.find<AuthService>();

  // Getters pour accéder facilement aux infos utilisateur
  User? get currentUser => _userService.user;
  String get userName => _userService.userName ?? 'Nom Inconnu';
  String get userEmail => _userService.userEmail ?? 'Email non disponible';
  String get userRole => _getRoleDisplay(_userService.userRole ?? '');
  String get userImageUrl => _userService.userImageUrl ?? 
      'https://www.pngall.com/wp-content/uploads/5/Profile-PNG-High-Quality-Image.png';

  @override
  void onInit() {
    super.onInit();
    print('ProfileController: Initialisé avec utilisateur ${userName}');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// Convertir le rôle technique en libellé d'affichage
  String _getRoleDisplay(String role) {
    switch (role) {
      case 'learner':
        return 'Apprenant(e)';
      case 'teacher':
        return 'Enseignant(e)';
      case 'parent':
        return 'Parent';
      case 'responsable':
        return 'Responsable';
      default:
        return 'Rôle inconnu';
    }
  }

  /// Navigation vers la page de modification du profil
  void goToEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  /// Navigation vers les classes selon le rôle
  void goToClasses() {
    if (_userService.isTeacher) {
      Get.toNamed(Routes.CLASS_TEACHER);
    } else if (_userService.isLearner) {
      Get.toNamed(Routes.CLASS_STUDENT);
    } else {
      Get.snackbar(
        'Info',
        'Fonctionnalité non disponible pour votre rôle',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    Get.defaultDialog(
      title: 'Déconnexion',
      middleText: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      textConfirm: 'Oui',
      textCancel: 'Non',
      confirmTextColor: Get.theme.colorScheme.onPrimary,
      onConfirm: () async {
        Get.back(); // Fermer le dialog
        await _authService.logout(); // Utiliser AuthService pour la déconnexion
        Get.snackbar(
          'Déconnexion',
          'Vous avez été déconnecté avec succès',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
