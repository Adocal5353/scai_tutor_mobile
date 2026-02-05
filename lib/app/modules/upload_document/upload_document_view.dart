import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';

import 'upload_document_controller.dart';

class UploadDocumentView extends GetView<UploadDocumentController> {
  const UploadDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F8),
      appBar: AppBar(
        backgroundColor: SC_ThemeColors.darkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: controller.goBack,
        ),
        title: const Text(
          'Charger un Document',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.isLoadingClasses.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Message d'information
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: SC_ThemeColors.lightBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: SC_ThemeColors.darkBlue.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.info_outline, 
                            color: Color(0xFF104BBF), 
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Note : Cette version enregistre les métadonnées du document. Le fichier sera ajouté ultérieurement.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Titre
                    const Text(
                      'Titre du Document',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.titreController,
                      decoration: InputDecoration(
                        hintText: 'Ex: Cours de Français - Les Figures de Style',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Type
                    const Text(
                      'Type de Document',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.typeController,
                      decoration: InputDecoration(
                        hintText: 'Ex: PDF, Word, Exercice, Cours',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Matière
                    const Text(
                      'Matière',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller.matiereController,
                      decoration: InputDecoration(
                        hintText: 'Ex: Mathématiques, Français, Physique',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Classe
                    const Text(
                      'Classe',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: controller.classes.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.all(14.0),
                                child: Text(
                                  'Aucune classe disponible',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            : DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: controller.selectedClasse.value?.id,
                                  hint: const Text('Sélectionnez une classe'),
                                  items: controller.classes.map((classe) {
                                    return DropdownMenuItem<String>(
                                      value: classe.id,
                                      child: Text('${classe.subject} - ${classe.level}'),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    if (value != null) {
                                      controller.selectedClasse.value =
                                          controller.classes.firstWhere(
                                        (c) => c.id == value,
                                      );
                                    }
                                  },
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Document payant switch
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Document payant',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Obx(
                            () => Switch(
                              value: controller.estPayant.value,
                              onChanged: controller.togglePayant,
                              activeColor: SC_ThemeColors.normalGreen,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Prix (conditionnel)
                    Obx(
                      () => controller.estPayant.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'Prix (FCFA)',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controller.prixController,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,2}'),
                                    ),
                                  ],
                                  decoration: InputDecoration(
                                    hintText: 'Ex: 2500',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    prefixIcon: const Icon(Icons.attach_money),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 20),

                    // Visibilité
                    const Text(
                      'Visibilité',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Obx(
                        () => Column(
                          children: [
                            RadioListTile<String>(
                              value: 'public',
                              groupValue: controller.visibilite.value,
                              onChanged: (value) => controller.setVisibilite(value!),
                              title: const Text('Public'),
                              subtitle: const Text(
                                'Visible par tous',
                                style: TextStyle(fontSize: 12),
                              ),
                              activeColor: SC_ThemeColors.darkBlue,
                            ),
                            RadioListTile<String>(
                              value: 'prive',
                              groupValue: controller.visibilite.value,
                              onChanged: (value) => controller.setVisibilite(value!),
                              title: const Text('Privé'),
                              subtitle: const Text(
                                'Visible uniquement par la classe sélectionnée',
                                style: TextStyle(fontSize: 12),
                              ),
                              activeColor: SC_ThemeColors.darkBlue,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Bouton Enregistrer
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.uploadDocument,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: SC_ThemeColors.normalGreen,
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Enregistrer le Document',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
