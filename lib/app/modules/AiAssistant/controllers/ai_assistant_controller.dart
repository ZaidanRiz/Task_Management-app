import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';

class AiAssistantController extends GetxController {
  // Controller untuk input text
  final messageController = TextEditingController();
  
  // Controller untuk Scroll (agar otomatis scroll ke bawah saat chat baru muncul)
  final ScrollController scrollController = ScrollController();

  // List Pesan (Reactive)
  var messages = <Message>[].obs;
  
  // Status Loading (saat AI "mengetik")
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Pesan sapaan awal dari AI
    messages.add(
      Message(
        text: "Halo! Saya asisten pintar Anda. Ada yang bisa saya bantu terkait tugas hari ini?",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  // Fungsi Kirim Pesan
  void sendMessage() {
    String text = messageController.text.trim();
    if (text.isEmpty) return;

    // 1. Tambahkan pesan User
    messages.add(Message(text: text, isUser: true, timestamp: DateTime.now()));
    messageController.clear();
    _scrollToBottom();

    // 2. Simulasi AI Berpikir
    isLoading.value = true;

    // 3. Delay simulasi (Nanti diganti call API)
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      
      // 4. Tambahkan Balasan AI (Logika Dummy Sederhana)
      String reply = _getAiReply(text);
      messages.add(Message(text: reply, isUser: false, timestamp: DateTime.now()));
      _scrollToBottom();
    });
  }

  // Logika Dummy AI (Bisa diganti Real AI nanti)
  String _getAiReply(String input) {
    input = input.toLowerCase();
    if (input.contains('tugas') || input.contains('task')) {
      return "Jangan lupa cek halaman 'All Tasks' untuk melihat daftar lengkap pekerjaanmu.";
    } else if (input.contains('halo') || input.contains('hi')) {
      return "Halo juga! Tetap semangat produktif ya!";
    } else if (input.contains('kalender') || input.contains('date')) {
      return "Kamu bisa mengatur jadwal di halaman Calendar.";
    } else {
      return "Maaf, saya masih belajar. Bisa ulangi pertanyaanmu tentang manajemen tugas?";
    }
  }

  // Helper untuk auto-scroll ke pesan terakhir
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}