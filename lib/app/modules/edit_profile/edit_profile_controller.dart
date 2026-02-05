import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/providers/apprenant_provider.dart';
import '../../data/providers/enseignant_provider.dart';
import '../../data/providers/parent_provider.dart';
import '../../data/providers/api_provider.dart';
import '../../data/services/user_service.dart';
import '../../data/models/user.dart';

class EditProfileController extends GetxController {
  final ApprenantProvider _apprenantProvider = ApprenantProvider(Get.find<ApiProvider>());
  final EnseignantProvider _enseignantProvider = EnseignantProvider(Get.find<ApiProvider>());
  final ParentProvider _parentProvider = ParentProvider(Get.find<ApiProvider>());
  final UserService _userService = Get.find<UserService>();
  final ImagePicker _picker = ImagePicker();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController emailController;
  late TextEditingController telephoneController;
  
  final RxBool isLoading = false.obs;
  final RxString selectedImagePath = ''.obs;
  final RxString selectedNiveau = ''.obs;
  final RxString selectedSpecialite = ''.obs;

  final List<String> niveaux = [
    'Primaire',
    'Collège',
    'Lycée',
    'Université',
  ];

  final List<String> specialites = [
    'Mathématiques',
    'Physique',
    'Chimie',
    'Histoire',
    'Géographie',
    'Français',
    'Anglais',
    'Informatique',
    'SVT',
  ];

  bool get isLearner => _userService.userRole == 'learner';
  bool get isTeacher => _userService.userRole == 'teacher';
  bool get isParent => _userService.userRole == 'parent';

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
  }

  void _initializeControllers() {
    final userName = _userService.userName ?? '';
    final nameParts = userName.split(' ');
    
    nomController = TextEditingController(text: nameParts.length > 1 ? nameParts.last : '');
    prenomController = TextEditingController(text: nameParts.isNotEmpty ? nameParts.first : '');
    emailController = TextEditingController(text: _userService.userEmail ?? '');
    telephoneController = TextEditingController();
    
    // Initialize default values - these would ideally come from user data
    if (isLearner) {
      selectedNiveau.value = 'Collège';
    }
    if (isTeacher) {
      selectedSpecialite.value = 'Mathématiques';
    }
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de sélectionner une image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    
    try {
      // DEBUG: Check what's in storage
      final storage = GetStorage();
      print('[DEBUG] ========== EDIT PROFILE DEBUG ==========');
      print('[DEBUG] Token: ${storage.read('token')}');
      print('[DEBUG] User data: ${storage.read('user')}');
      print('[DEBUG] User type: ${storage.read('user_type')}');
      
      // DEBUG: Check UserService state
      print('[DEBUG] UserService.currentUser: ${_userService.currentUser.value}');
      print('[DEBUG] UserService.isLoggedIn: ${_userService.isLoggedIn}');
      print('[DEBUG] UserService.userId: ${_userService.userId}');
      print('[DEBUG] UserService.userName: ${_userService.userName}');
      print('[DEBUG] UserService.userRole: ${_userService.userRole}');
      print('[DEBUG] =========================================');
      
      final userId = _userService.userId;
      if (userId == null || userId.isEmpty) {
        throw Exception('Utilisateur non connecté - userId est null ou vide');
      }
      
      final role = _userService.userRole;
      
      print('[EditProfile] Mise à jour du profil - userId: $userId, role: $role');
      
      Map<String, dynamic> data = {
        'nom': nomController.text.trim(),
        'prenom': prenomController.text.trim(),
        'email': emailController.text.trim(),
      };
      
      if (role == 'learner') {
        data['niveau_scolaire'] = selectedNiveau.value;
        await _apprenantProvider.update(userId, data);
      } else if (role == 'teacher') {
        data['specialite'] = selectedSpecialite.value;
        if (telephoneController.text.isNotEmpty) {
          data['telephone'] = telephoneController.text.trim();
        }
        await _enseignantProvider.update(userId, data);
      } else if (role == 'parent') {
        if (telephoneController.text.isNotEmpty) {
          data['telephone'] = telephoneController.text.trim();
        }
        await _parentProvider.update(userId, data);
      }
      
      // Update UserService with new data
      final updatedUser = User(
        id: userId,
        role: role,
        name: '${data['prenom']} ${data['nom']}',
        email: data['email'],
        imageUrl: selectedImagePath.value.isNotEmpty 
          ? selectedImagePath.value 
          : (_userService.userImageUrl ?? 'assets/icons/utilisateur.png'),
        token: _userService.user?.token,
      );
      _userService.updateUser(updatedUser);
      
      Get.back();
      Get.snackbar(
        'Succès',
        'Profil mis à jour avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de mettre à jour le profil: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nomController.dispose();
    prenomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    super.onClose();
  }
}
