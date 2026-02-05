import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:image_picker/image_picker.dart';

import 'sc_ai_bot_controller.dart';

class ScsAIBotView extends GetView<ScsAIBotController> {
  const ScsAIBotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(FontAwesomeIcons.robot, size: 30),
            const SizedBox(width: 8),
            const Text('ScAI Bot'),
          ],
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'Historique':
                  Get.snackbar('Historique', 'Fonction à implémenter');
                  break;
                case 'Aide':
                  Get.snackbar('Aide', 'Fonction à implémenter');
                  break;
                case 'À propos':
                  Get.snackbar(
                    'À propos',
                    'ScAI Bot v1.0\nDéveloppé par ScAI Tutor',
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Historique',
                child: Text('Historique'),
              ),
              const PopupMenuItem<String>(value: 'Aide', child: Text('Aide')),
              const PopupMenuItem<String>(
                value: 'À propos',
                child: Text('À propos'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final message = controller.messages[index];
                  return Align(
                    alignment: message.isBot
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.isBot) ...[
                          const Icon(FontAwesomeIcons.robot, size: 30),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.imagePath != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(message.imagePath!),
                                    width: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Text(
                                        'Erreur de chargement de l\'image',
                                      );
                                    },
                                  ),
                                ),
                                if (message.text.isNotEmpty)
                                  const SizedBox(height: 8),
                              ],
                              // Render bot messages as Markdown, user messages as plain text
                              message.isBot
                                  ? GptMarkdown(
                                      message.text,
                                      style: const TextStyle(fontSize: 16),
                                    )
                                  : Text(
                                      message.text,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                            ],
                          ),
                        ),
                        if (!message.isBot) const SizedBox(width: 38),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.textController,
                        decoration: InputDecoration(
                          hintText: 'Envoyer un message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            color: Colors.white,
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Prendre une photo'),
                                  onTap: () =>
                                      controller.pickImage(ImageSource.camera),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text(
                                    'Choisir depuis la galerie',
                                  ),
                                  onTap: () =>
                                      controller.pickImage(ImageSource.gallery),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Obx(
                      () => IconButton(
                        icon: Icon(
                          controller.textController.text.isEmpty &&
                                  controller.selectedImage.value == null
                              ? controller.isListening.value
                                    ? Icons.mic_off
                                    : Icons.mic
                              : Icons.send,
                        ),
                        onPressed: () {
                          if (controller.textController.text.isEmpty &&
                              controller.selectedImage.value == null) {
                            if (controller.isListening.value) {
                              controller.stopListening();
                            } else {
                              controller.startListening();
                            }
                          } else {
                            controller.sendMessage();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // Image preview with delete button
                Obx(
                  () => controller.selectedImage.value != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  controller.selectedImage.value!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Text(
                                      'Erreur de chargement de l\'image',
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: GestureDetector(
                                  onTap: controller.clearImage,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
