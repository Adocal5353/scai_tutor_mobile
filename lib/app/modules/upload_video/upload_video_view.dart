import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'package:scai_tutor_mobile/app/data/models/classe.dart';

import 'upload_video_controller.dart';

class UploadVideoView extends GetView<UploadVideoController> {
  const UploadVideoView({super.key});

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
          'Charger une Vidéo',
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
                    // Section de Sélection de Vidéo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: SC_ThemeColors.darkBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Vidéo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                'Obligatoire',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Obx(() {
                            final file = controller.selectedFile.value;
                            if (file != null) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: SC_ThemeColors.lightBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: SC_ThemeColors.darkBlue.withOpacity(0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.video_file,
                                      color: SC_ThemeColors.darkBlue,
                                      size: 32,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            file.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            controller.formatFileSize(file.size),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: controller.removeSelectedFile,
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ElevatedButton.icon(
                              onPressed: controller.pickVideo,
                              icon: const Icon(Icons.video_library),
                              label: const Text('Sélectionner une vidéo'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: SC_ThemeColors.darkBlue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }),
                          Obx(() {
                            if (controller.fileError.value.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  controller.fileError.value,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          const SizedBox(height: 8),
                          Text(
                            'Formats acceptés: MP4, AVI, MOV, WMV, FLV, MKV, WEBM, M4V\nTaille max: 100 Mo',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Formulaire
                    _buildTextField(
                      controller: controller.titreController,
                      label: 'Titre de la vidéo',
                      hint: 'Ex: Introduction aux mathématiques',
                      icon: Icons.title,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: controller.matiereController,
                      label: 'Matière',
                      hint: 'Ex: Mathématiques',
                      icon: Icons.book,
                      required: true,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: controller.descriptionController,
                      label: 'Description',
                      hint: 'Description de la vidéo (optionnel)',
                      icon: Icons.description,
                      maxLines: 3,
                      required: false,
                    ),
                    const SizedBox(height: 16),

                    // Sélection de classe
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: SC_ThemeColors.darkBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.class_, color: SC_ThemeColors.darkBlue),
                              const SizedBox(width: 8),
                              const Text(
                                'Classe',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                ' *',
                                style: TextStyle(color: Colors.red, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Obx(() => DropdownButtonFormField<Classe>(
                                value: controller.selectedClasse.value,
                                decoration: InputDecoration(
                                  hintText: 'Sélectionner une classe',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                items: controller.classes.map((classe) {
                                  return DropdownMenuItem(
                                    value: classe,
                                    child: Text(classe.subject),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectedClasse.value = value;
                                },
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Visibilité
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: SC_ThemeColors.darkBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.visibility, color: SC_ThemeColors.darkBlue),
                              const SizedBox(width: 8),
                              const Text(
                                'Visibilité',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Obx(() => Column(
                                children: [
                                  RadioListTile<String>(
                                    title: const Text('Public'),
                                    value: 'public',
                                    groupValue: controller.visibilite.value,
                                    onChanged: (value) {
                                      if (value != null) controller.setVisibilite(value);
                                    },
                                    activeColor: SC_ThemeColors.darkBlue,
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('Privé'),
                                    value: 'prive',
                                    groupValue: controller.visibilite.value,
                                    onChanged: (value) {
                                      if (value != null) controller.setVisibilite(value);
                                    },
                                    activeColor: SC_ThemeColors.darkBlue,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Bouton Enregistrer
                    Obx(() => SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.uploadVideo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: SC_ThemeColors.normalGreen,
                              disabledBackgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
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
                                    'Enregistrer la vidéo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: SC_ThemeColors.darkBlue.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: SC_ThemeColors.darkBlue),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
