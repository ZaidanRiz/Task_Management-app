import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart'; // Import Controller Global
import 'package:task_management_app/app/data/models/task_model.dart';      // Import Model Task

class CreateTaskController extends GetxController {
  // 1. Menemukan (Find) Controller Global untuk menyimpan data nanti
  final TaskController globalTaskController = Get.find<TaskController>();

  // Controller untuk TextFields
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  
  // Data Label Hari
  final List<String> daysLabel = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];
  
  // State Hari yang dipilih (RxList agar reaktif update UI)
  var selectedDays = <bool>[false, false, false, false, false, false, false].obs;

  // Fungsi untuk mengubah status hari (Centang/Uncentang)
  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
  }

  // Fungsi Submit (Simpan Data)
  void submitTask() {
    // A. Validasi Input
    if (titleController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nama misi tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }

    // B. Membuat Objek Task Baru
    final newTask = TaskModel(
      title: titleController.text,
      project: "Personal", // Bisa diubah jadi inputan user jika mau
      progress: 0,         // Task baru mulai dari 0
      total: 10,           // Total steps default (bisa diubah nanti)
      // Gunakan tanggal inputan, atau default ke hari ini jika kosong
      date: dateController.text.isEmpty ? "Today" : dateController.text,
      dateColor: Colors.blue,      // Warna default
      progressColor: Colors.blue,  // Warna default
    );

    // C. Simpan ke Global Controller
    globalTaskController.addTask(newTask);

    // D. Feedback ke User & Tutup Halaman
    Get.snackbar(
      "Berhasil",
      "Task '${titleController.text}' berhasil ditambahkan!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      duration: const Duration(seconds: 1),
    );

    // Delay sedikit sebelum menutup halaman agar notifikasi terlihat
    Future.delayed(const Duration(milliseconds: 1200), () {
      Get.back(); // Kembali ke halaman sebelumnya
    });
  }

  @override
  void onClose() {
    // Bersihkan memori saat controller dimatikan
    titleController.dispose();
    dateController.dispose();
    super.onClose();
  }
}