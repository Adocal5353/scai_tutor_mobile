import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/data/models/message_model.dart';

class ClassChatController extends GetxController {
  final messageController = TextEditingController();
  final messages = <MessageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void _loadInitialMessages() {
    messages.value = [
      MessageModel(
        sender: "Monafa Antoine",
        time: "20:00",
        text: "Bonsoir à tous. Ce soir nous allons aborder le dernier chapitre en géométrie",
        isMe: false,
        avatar: "assets/icons/antoine.png",
      ),
      MessageModel(
        sender: "Akoesso Justine",
        time: "20:02",
        text: "Les élèves peuvent poser leurs questions ici à tous moments ?",
        isMe: true,
        avatar: "assets/icons/utilisateur.png",
      ),
      MessageModel(
        sender: "Dom Justin",
        time: "20:09",
        text: "Bonsoir à tous. Ce soir nous allons aborder le dernier chapitre en géométrie.",
        isMe: false,
        avatar: "assets/icons/justin.png",
      ),
      MessageModel(
        sender: "Akoesso Justine",
        time: "20:02",
        text: "Les élèves peuvent poser leurs questions ici à tous moments ?",
        isMe: true,
        avatar: "assets/icons/utilisateur.png",
      ),
    ];
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = MessageModel(
      sender: "Moi",
      time: _getCurrentTime(),
      text: messageController.text.trim(),
      isMe: true,
      avatar: "assets/icons/utilisateur.png",
    );

    messages.add(newMessage);
    messageController.clear();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void goBack() {
    Get.back();
  }
}
