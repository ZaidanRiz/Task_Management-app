import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class CreateTaskController extends GetxController {
  final TaskController globalTaskController = Get.find<TaskController>();

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  // Daftar dinamis field sub task
  final RxList<TextEditingController> stepControllers =
      <TextEditingController>[].obs;

  var isLoading = false.obs;
  var selectedDateTime = DateTime.now().obs;

  final List<String> daysLabel = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

  var selectedDays =
      <bool>[false, false, false, false, false, false, false].obs;

  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
  }

  @override
  void onInit() {
    super.onInit();
    // Pastikan minimal ada 1 field sub task
    stepControllers.add(TextEditingController());
  }

  // --- PERBAIKAN DATE FORMAT: Tambahkan TAHUN (yyyy) ---
  void setSelectedDate(DateTime pickedDate) {
    selectedDateTime.value = pickedDate;

    // Format yang konsisten dengan CalendarController: 'd MMM yyyy'
    final formattedDate = DateFormat('d MMM yyyy').format(pickedDate);
    dateController.text = formattedDate;
  }
  // --- END PERBAIKAN DATE FORMAT ---

  // Kelola field sub task dinamis
  void addStepField() {
    stepControllers.add(TextEditingController());
  }

  void removeStepField(int index) {
    if (stepControllers.length <= 1) return; // jaga minimal 1
    final ctrl = stepControllers.removeAt(index);
    ctrl.dispose();
  }

  void submitTask() async {
    // Bangun todos dari field langkah yang tidak kosong
    final List<Map<String, dynamic>> newTodos = stepControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .map((t) => {'title': t, 'isCompleted': false})
        .toList();

    if (titleController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        newTodos.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nama Tugas, minimal 1 Sub Task, dan Tanggal tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }

    isLoading.value = true; // Mulai loading

    // 2. Buat TaskModel (Mengembalikan progress/total yang hilang)
    final newTask = TaskModel(
      id: DateTime.now().toString(),
      title: titleController.text,
      project: "Personal",
      date: dateController.text, // Sekarang termasuk Tahun
      dateColor: Colors.blue,
      progressColor: Colors.blue,
      todos: newTodos,
    );
    try {
      await globalTaskController.addTask(newTask);

      Get.snackbar(
        "Berhasil",
        "Task '${titleController.text}' berhasil ditambahkan!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 1),
      );

      // 3. Transisi Asinkron (Menghilangkan kesan 'stuck')
      await Future.delayed(const Duration(milliseconds: 1200));

      // Navigasi ke All Tasks View
      globalTaskController.assignTaskCategories();
      Get.offNamed('/description');
    } catch (e) {
      final msg = e.toString();
      Get.snackbar(
        "Gagal",
        msg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    for (final c in stepControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
