import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../global_widgets/primary_button.dart';
import '../../theme/theme_colors.dart';
import 'edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              // AppBar
              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                  bottom: 10,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Get.back(),
                    ),
                    const Text(
                      'Modifier le profil',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: SC_ThemeColors.lightGreyBg,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : _buildForm(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Photo picker
            _buildPhotoPicker(),
            const SizedBox(height: 40),
            // Form fields
            _buildTextField(
              'Nom',
              controller.nomController,
              Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              'Prénom',
              controller.prenomController,
              Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre prénom';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              'Email',
              controller.emailController,
              Icons.email_outlined,
              enabled: false,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                if (!GetUtils.isEmail(value.trim())) {
                  return 'Email invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Conditional fields based on role
            if (controller.isLearner) ...[
              _buildDropdown(
                'Niveau Scolaire',
                controller.niveaux,
                controller.selectedNiveau,
                Icons.school_outlined,
              ),
              const SizedBox(height: 20),
            ],
            if (controller.isTeacher) ...[
              _buildDropdown(
                'Spécialité',
                controller.specialites,
                controller.selectedSpecialite,
                Icons.subject_outlined,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                'Téléphone',
                controller.telephoneController,
                Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
            ],
            if (controller.isParent) ...[
              _buildTextField(
                'Téléphone',
                controller.telephoneController,
                Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 20),
            // Save button
            PrimaryButton(
              text: 'Enregistrer',
              onPressed: controller.saveProfile,
              backgroundColor: SC_ThemeColors.darkBlue,
              radius: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: controller.pickImage,
      child: Obx(() {
        return Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: controller.selectedImagePath.value.isNotEmpty
                  ? FileImage(File(controller.selectedImagePath.value))
                  : const AssetImage('assets/icons/utilisateur.png') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: SC_ThemeColors.darkBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController textController,
    IconData icon, {
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: textController,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: SC_ThemeColors.darkBlue),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SC_ThemeColors.darkBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    RxString selectedValue,
    IconData icon,
  ) {
    return Obx(() {
      return DropdownButtonFormField<String>(
        value: selectedValue.value.isEmpty ? null : selectedValue.value,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: SC_ThemeColors.darkBlue),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: SC_ThemeColors.darkBlue, width: 2),
          ),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            selectedValue.value = newValue;
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez sélectionner une option';
          }
          return null;
        },
      );
    });
  }
}
