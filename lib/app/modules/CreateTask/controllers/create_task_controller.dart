import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import 'package:task_management_app/app/controllers/task_controller.dart'; 
import 'package:task_management_app/app/data/models/task_model.dart'; 

class CreateTaskController extends GetxController {
  final TaskController globalTaskController = Get.find<TaskController>();

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final stepController = TextEditingController();

  var isLoading = false.obs;
  var selectedDateTime = DateTime.now().obs; 

  final List<String> daysLabel = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

  var selectedDays =
      <bool>[false, false, false, false, false, false, false].obs;

  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
  }

  // --- PERBAIKAN DATE FORMAT: Tambahkan TAHUN (yyyy) ---
  void setSelectedDate(DateTime pickedDate) {
    selectedDateTime.value = pickedDate;
    
    // Format yang konsisten dengan CalendarController: 'd MMM yyyy'
    final formattedDate = DateFormat('d MMM yyyy').format(pickedDate); 
    dateController.text = formattedDate; 
  }
  // --- END PERBAIKAN DATE FORMAT ---

  void submitTask() async {
    if (titleController.text.isEmpty ||
        stepController.text.isEmpty ||
        dateController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nama Tugas, Sub Tugas, dan Deadline Tanggal tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }
    
    isLoading.value = true; // START LOADING

    // 1. Buat list Todos
    final List<Map<String, dynamic>> newTodos = [
        {'title': stepController.text, 'isCompleted': false},
        {'title': 'Review Task', 'isCompleted': false},
    ];

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

    globalTaskController.addTask(newTask);

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

    isLoading.value = false;
    // Navigasi ke All Tasks View
    Get.offNamed('/description'); 
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    stepController.dispose();
    super.onClose();
  }
}