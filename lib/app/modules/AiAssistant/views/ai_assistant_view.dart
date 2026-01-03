import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/ai_assistant_controller.dart';
import '../models/message_model.dart';

class AiAssistantView extends GetView<AiAssistantController> {
  const AiAssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Background abu muda
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: const [
            Icon(Icons.lightbulb, color: Colors.yellow),
            SizedBox(width: 8),
            Text(
              'AI Assistant',
              style:
                  TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // --- LIST PESAN ---
          Expanded(
            child: Obx(() {
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _buildChatBubble(msg);
                },
              );
            }),
          ),

          // --- INDIKATOR LOADING (Saat AI mengetik) ---
          Obx(() => controller.isLoading.value
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text("AI is typing...",
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ),
                )
              : const SizedBox.shrink()),

          // --- INPUT FIELD ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 5, offset: Offset(0, -2))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.messageController,
                    decoration: InputDecoration(
                      hintText: "Ask something...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onSubmitted: (_) =>
                        controller.sendMessage(), // Kirim saat tekan enter
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => controller.sendMessage(),
                  child: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 24,
                    child: Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Bubble Chat
  Widget _buildChatBubble(Message msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints:
            const BoxConstraints(maxWidth: 250), // Lebar maksimal bubble
        decoration: BoxDecoration(
          color: msg.isUser ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: msg.isUser ? const Radius.circular(15) : Radius.zero,
            bottomRight: msg.isUser ? Radius.zero : const Radius.circular(15),
          ),
          boxShadow: [
            if (!msg.isUser)
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 2))
          ],
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
