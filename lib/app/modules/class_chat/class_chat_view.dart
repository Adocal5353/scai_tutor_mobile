import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scai_tutor_mobile/app/theme/theme_colors.dart';
import 'class_chat_controller.dart';

class ClassChatView extends GetView<ClassChatController> {
  const ClassChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: SC_ThemeColors.darkBlue,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: controller.goBack,
        ),
        title: const Text(
          "Discussion de classe",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: controller.messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!msg.isMe) _buildAvatar(msg.avatar),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment:
                msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!msg.isMe)
                Text(
                  msg.sender,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: msg.isMe
                      ? SC_ThemeColors.lightBlueBg
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: msg.isMe
                        ? Colors.transparent
                        : Colors.black12,
                  ),
                ),
                child: Text(
                  msg.text,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                msg.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(String iconPath) {
    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        iconPath,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.messageController,
              decoration: InputDecoration(
                hintText: "Ecrire un message",
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: controller.sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: SC_ThemeColors.normalGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
