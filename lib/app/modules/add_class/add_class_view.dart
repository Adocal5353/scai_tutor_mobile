import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_class_controller.dart';

class AddClassView extends GetView<AddClassController> {
  const AddClassView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          /// --- BACKGROUND IMAGE ---
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Ellipse_image.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// --- CONTENT ---
          SafeArea(
            child: Column(
              children: [
                /// --- APP BAR avec LOGO ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Stack(
                    children: [
                      // Bouton retour à gauche
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: controller.goBack,
                        ),
                      ),
                      // Logo centré
                      Center(
                        child: Container(
                          height: 40,
                          width: 85,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// --- SCROLLABLE CONTENT ---
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        const Text(
                          "Créer une classe",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// --- NOM DE CLASSE ---
                        const Text(
                          "Nom de la classe",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.classNameController,
                          hint: "Saisissez le nom de la classe",
                        ),

                        const SizedBox(height: 18),

                        /// --- NIVEAU SCOLAIRE ---
                        const Text(
                          "Niveau scolaire",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => _buildDropdown(
                              label: "Niveau scolaire",
                              value: controller.selectedLevel.value,
                              hint: "Sélectionnez le niveau",
                              items: controller.levels,
                              onChanged: (v) => controller.selectedLevel.value = v,
                            )),

                        const SizedBox(height: 18),

                        /// --- MATIÈRE ---
                        const Text(
                          "Matière",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() => _buildDropdown(
                              label: "Matière",
                              value: controller.selectedSubject.value,
                              hint: "Sélectionnez la matière",
                              items: controller.subjects,
                              onChanged: (v) => controller.selectedSubject.value = v,
                            )),

                        const SizedBox(height: 18),

                        /// --- ÉTABLISSEMENT ---
                        const Text(
                          "Établissement",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.establishmentController,
                          hint: "Entrez votre établissement",
                        ),

                        const SizedBox(height: 18),

                        /// --- DESCRIPTION ---
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: controller.descriptionController,
                          hint: "Ajoutez une description à la classe",
                          maxLines: 3,
                        ),

                        const SizedBox(height: 30),

                        /// --- BOUTON CRÉER ---
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF005CFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: controller.createClass,
                            child: const Text(
                              "Créer",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// --- TEXTFIELD WIDGET ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }

  /// --- DROPDOWN WIDGET ---
  Widget _buildDropdown({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black12),
        ),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
