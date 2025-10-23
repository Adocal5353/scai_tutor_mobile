import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/modules/signup/time_on_screen_view.dart';
import 'package:scai_tutor_mobile/app/routes/app_pages.dart';

import 'signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({super.key});

  final List<Map<String, dynamic>> profileOptions = [
    {'label': 'Apprenant', 'value': 'learner', 'icon': Icons.school},
    {'label': 'Enseignant', 'value': 'teacher', 'icon': Icons.person},
    {'label': 'Parent', 'value': 'parent', 'icon': Icons.family_restroom},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header (logo et titre)
                  _buildHeader(),

                  // Section avec fond d'écran qui occupe tout l'espace restant
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/login_background.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: const Text(
                                  'Choisir un profil',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Boutons de profil
                              Obx(
                                () => Row(
                                  children: profileOptions.map((option) {
                                    return _buildProfileButton(
                                      icon: option['icon'],
                                      label: option['label'],
                                      value: option['value'],
                                      isSelected:
                                          controller.selectedProfile.value ==
                                          option['value'],
                                    );
                                  }).toList(),
                                ),
                              ),

                              // Ajoutez ici vos autres champs de formulaire...
                              const SizedBox(height: 20),
                              _buildInputField(label: 'Nom et prénom(s)'),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Email',
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),
                              
                              // Dropdown Niveau (conditionnel selon profil)
                              Obx(() {
                                if (controller.selectedProfile.value == 'learner' || 
                                    controller.selectedProfile.value == 'teacher') {
                                  return Column(
                                    children: [
                                      _buildDropdown(
                                        label: controller.niveauLabel,
                                        items: controller.niveaux,
                                        value: controller.niveau.value,
                                        onChanged: controller.selectNiveau,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              
                              // Dropdown Spécialité (uniquement pour enseignant)
                              Obx(() {
                                if (controller.showSpecialite) {
                                  return Column(
                                    children: [
                                      _buildDropdown(
                                        label: "Spécialité",
                                        items: controller.specialites,
                                        value: controller.specialite.value,
                                        onChanged: controller.selectSpecialite,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              
                              _buildInputField(
                                label: "Etablissement",
                                keyboardType: TextInputType.text,
                              ),
                              const SizedBox(height: 16),
                              
                              // Champ Téléphone (uniquement pour apprenant)
                              Obx(() {
                                if (controller.selectedProfile.value == 'learner') {
                                  return Column(
                                    children: [
                                      _buildInputField(
                                        label: "Téléphone",
                                        keyboardType: TextInputType.phone,
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              
                              _buildInputField(
                                label: 'Mot de passe',
                                isPassword: true,
                              ),
                              const SizedBox(height: 16),
                              _buildInputField(
                                label: 'Confirmer le mot de passe',
                                isPassword: true,
                              ),
                              const SizedBox(height: 16),

                              // Bouton Téléverser une photo
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.photo_camera),
                                label: const Text('Téléverser une photo'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 50),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Bouton Créer un compte
                              ElevatedButton(
                                onPressed: () {
                                  Get.to(TimeOnScreenView());
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: Color.fromRGBO(
                                    16,
                                    75,
                                    191,
                                    1,
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                ),
                                child: const Text(
                                  'Suivant',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Lien de connexion
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    Get.toNamed(Routes.LOGIN);
                                  },
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Déjà un compte ? ',
                                      children: [
                                        TextSpan(
                                          text: 'Connexion',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 45,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset('assets/images/app_logo.png'),
        ),
        const SizedBox(height: 10),
        Center(
          child: const Text(
            'Créer un compte',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileButton({
    required String label,
    required String value,
    required IconData icon,
    required bool isSelected,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        child: OutlinedButton(
          onPressed: () => controller.selectProfile(value),
          style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue[50] : null,
            side: BorderSide(
              color: isSelected ? Colors.blue : Colors.black26,
              width: isSelected ? 2.0 : 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cercle avec icône
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 30.0,
                  color: isSelected ? Colors.white : Colors.blue,
                ),
              ),
              const SizedBox(height: 15.0),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(label),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.0),
        ),
        items: items
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
