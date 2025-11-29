import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../data/services/user_service.dart';
import '../../data/models/user.dart';

class LoginController extends GetxController {
  // Injection du UserService
  final UserService _userService = Get.find<UserService>();

  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxString errorMessage = ''.obs;

  // Faux utilisateurs pour test 
  final Map<String, Map<String, dynamic>> _fakeUsers = {
    'apprenant@test.com': {
      'password': '123456',
      'role': 'learner',
      'name': 'Rodrigue Apprenant',
    },
    'enseignant@test.com': {
      'password': '123456',
      'role': 'teacher',
      'name': 'Caleb Enseignant',
    },
    'parent@test.com': {
      'password': '123456',
      'role': 'parent',
      'name': 'Junior Parent',
    },
  };

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// Validation de l'email
  bool _validateEmail(String email) {
    if (email.isEmpty) {
      errorMessage.value = 'L\'email est requis';
      return false;
    }
    
    // Regex pour valider l'email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      errorMessage.value = 'Email invalide';
      return false;
    }
    
    return true;
  }

  /// Validation du mot de passe
  bool _validatePassword(String password) {
    if (password.isEmpty) {
      errorMessage.value = 'Le mot de passe est requis';
      return false;
    }
    
    if (password.length < 6) {
      errorMessage.value = 'Le mot de passe doit contenir au moins 6 caractères';
      return false;
    }
    
    return true;
  }

  /// Méthode de connexion principale
  Future<void> login() async {
    // Validation des champs
    if (!_validateEmail(emailController.text.trim())) {
      _showErrorSnackbar(errorMessage.value);
      return;
    }

    if (!_validatePassword(passwordController.text)) {
      _showErrorSnackbar(errorMessage.value);
      return;
    }

    // Démarrer le loading
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Simulation d'appel API 
      final result = await _fakeApiLogin(
        emailController.text.trim(),
        passwordController.text,
      );

      if (result['success']) {
        // Stocker les informations utilisateur 
        _saveUserData(result['user']);

        // Message de succès
        Get.snackbar(
          'Succès',
          'Bienvenue ${result['user']['name']} !',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        // Navigation selon le rôle (décommenter et adapter selon vos routes)
        await Future.delayed(Duration(milliseconds: 500));
        _navigateByRole(result['user']['role']);
        
      } else {
        _showErrorSnackbar(result['message']);
      }
    } catch (e) {
      _showErrorSnackbar('Une erreur est survenue. Veuillez réessayer.');
      print('Erreur de connexion: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Simulation d'appel API 
  Future<Map<String, dynamic>> _fakeApiLogin(String email, String password) async {
    // Simulation de délai réseau
    await Future.delayed(Duration(seconds: 2));

    // Vérification des identifiants 
    if (_fakeUsers.containsKey(email)) {
      if (_fakeUsers[email]!['password'] == password) {
        return {
          'success': true,
          'user': {
            'email': email,
            'name': _fakeUsers[email]!['name'],
            'role': _fakeUsers[email]!['role'],
            'token': 'fake_jwt_token_${DateTime.now().millisecondsSinceEpoch}',
          },
        };
      } else {
        return {
          'success': false,
          'message': 'Mot de passe incorrect',
        };
      }
    }

    return {
      'success': false,
      'message': 'Aucun compte trouvé avec cet email',
    };
  }

  /// Sauvegarder les données utilisateur 
  void _saveUserData(Map<String, dynamic> userData) {
    // Créer un objet User à partir des données
    final user = User(
      id: userData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: userData['name'],
      email: userData['email'],
      role: userData['role'],
      token: userData['token'],
      imageUrl: userData['imageUrl'] ?? '',
    );

    // Enregistrer dans le UserService (qui gérera aussi le stockage local)
    _userService.setUser(user);
    
    print('Utilisateur connecté: ${user.name} (${user.role})');
  }

  /// Navigation selon le rôle utilisateur
  void _navigateByRole(String role) {
    switch (role) {
      case 'learner':
        Get.offAllNamed(Routes.DASHBOARD_STUDENT);
        break;
      case 'teacher':
        Get.offAllNamed(Routes.DASHBOARD_TEACHER);
        break;
      case 'parent':
        Get.offAllNamed(Routes.PARENT_GUARDIAN);
        break;
      default:
        Get.snackbar('Erreur', 'Rôle utilisateur non reconnu');
    }
  }

  /// Connexion avec Google
  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    
    try {
      // TODO: Implémenter la connexion avec Google Sign-In
      // 1. Initialiser GoogleSignIn
      // 2. Appeler signIn()
      // 3. Récupérer le token
      // 4. Envoyer à l'API backend
      
      await Future.delayed(Duration(seconds: 2));
      
      Get.snackbar(
        'Info',
        'Connexion avec Google à implémenter',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      _showErrorSnackbar('Erreur lors de la connexion Google');
      print('Erreur Google Sign-In: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Récupération de mot de passe
  Future<void> forgotPassword() async {
    final email = emailController.text.trim();
    
    if (!_validateEmail(email)) {
      _showErrorSnackbar('Veuillez entrer un email valide');
      return;
    }

    isLoading.value = true;
    
    try {
      // TODO: Appel API pour envoyer email de réinitialisation
      await Future.delayed(Duration(seconds: 2));
      
      Get.snackbar(
        'Succès',
        'Un email de réinitialisation a été envoyé à $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _showErrorSnackbar('Erreur lors de l\'envoi de l\'email');
      print('Erreur mot de passe oublié: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Afficher un snackbar d'erreur
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Erreur',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  @override
  void onInit() {
    super.onInit();
    // Pré-remplir pour test 
    // emailController.text = 'apprenant@test.com';
    // passwordController.text = '123456';
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}