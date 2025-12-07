import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart'; // Import Controller Global
import 'package:task_management_app/app/data/models/task_model.dart'; // Import Model Task

class CreateTaskController extends GetxController {
  // 1. Menemukan (Find) Controller Global untuk menyimpan data nanti
  final TaskController globalTaskController = Get.find<TaskController>();

  // Controller untuk TextFields
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final stepController = TextEditingController();

  // Data Label Hari
  final List<String> daysLabel = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

  // State Hari yang dipilih (RxList agar reaktif update UI)
  var selectedDays =
      <bool>[false, false, false, false, false, false, false].obs;

  // Fungsi untuk mengubah status hari (Centang/Uncentang)
  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
  }

  // Fungsi Submit (Simpan Data)
  void submitTask() {
    // 1. UPDATE VALIDASI: Cek Title ATAU Step ATAU Date
    if (titleController.text.isEmpty ||
        stepController.text.isEmpty ||
        dateController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nama Tugas, Sub Tugas, dan Deadline Tanggal tidak boleh kosong", // <-- Pesan disesuaikan
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }

    final newTask = TaskModel(
      id: DateTime.now().toString(), // Generate ID unik
      title: titleController.text,
      project: "Personal",
      date: dateController.text.isEmpty ? "Today" : dateController.text,
      dateColor: Colors.blue,
      progressColor: Colors.blue,
      // Masukkan sub-task dari input user
      todos: [
        {'title': stepController.text, 'isCompleted': false},
        // Bisa tambah default steps lain jika mau
        {'title': 'Review Task', 'isCompleted': false},
      ],
    );

    globalTaskController.addTask(newTask);

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

    Future.delayed(const Duration(milliseconds: 1200), () {
      Get.back();
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
