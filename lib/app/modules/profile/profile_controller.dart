import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/user.dart';
import 'package:scai_tutor_mobile/app/data/services/user_service.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  // Injection du UserService
  final UserService _userService = Get.find<UserService>();

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
      default:
        return 'Rôle inconnu';
    }
  }

  /// Navigation vers la page de modification du profil
  void goToEditProfile() {
    // TODO: Créer la page d'édition de profil
    Get.snackbar(
      'Info',
      'Page de modification du profil à implémenter',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Navigation vers les classes selon le rôle
  void goToClasses() {
    if (_userService.isTeacher) {
      // Naviguer vers les classes de l'enseignant
      Get.snackbar(
        'Navigation',
        'Redirection vers vos classes',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (_userService.isLearner) {
      // Naviguer vers les classes de l'apprenant
      Get.snackbar(
        'Navigation',
        'Redirection vers vos cours',
        snackPosition: SnackPosition.BOTTOM,
      );
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
        await _userService.logout();
        Get.back(); // Fermer le dialog
        Get.offAllNamed(Routes.LOGIN); // Rediriger vers login
        Get.snackbar(
          'Déconnexion',
          'Vous avez été déconnecté avec succès',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}
