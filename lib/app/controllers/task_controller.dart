//import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/task_model.dart';
import '../data/services/task_service.dart'; // Import Service

class TaskController extends GetxController {
  // Panggil Service
  final TaskService _taskService = TaskService();

  // State
  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs; // Untuk indikator loading

  @override
  void onInit() {
    super.onInit();
    // Panggil data saat aplikasi dibuka
    loadTasks();
  }

  // 1. READ (Ambil data dari Dummy API)
  void loadTasks() async {
    try {
      isLoading.value = true; // Mulai Loading
      
      // Ambil data dari service (menunggu 2 detik sesuai dummy)
      var fetchedTasks = await _taskService.fetchTasks();
      
      tasks.assignAll(fetchedTasks); // Masukkan ke list
    } finally {
      isLoading.value = false; // Selesai Loading
    }
  }

  // 2. CREATE (Tambah Data)
  void addTask(TaskModel task) async {
    // Simulasi kirim ke server
    await _taskService.addTask(task);
    
    // Update UI Lokal
    tasks.add(task);
    tasks.refresh();
  }

  // ... (Fungsi deleteTask dan toggleTodo biarkan tetap lokal untuk performa)
  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    tasks.refresh();
  }

  void toggleTodo(String taskId, int index) {
    var taskIndex = tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex != -1) {
      var task = tasks[taskIndex];
      task.todos[index]['isCompleted'] = !task.todos[index]['isCompleted'];
      tasks[taskIndex] = task; 
      tasks.refresh();
    }
  }

  // Helper Getters
  // (Logic sederhana: filter string tanggal)
  List<TaskModel> get todayTasks => tasks.where((e) => e.date.contains('Nov')).toList(); 
  List<TaskModel> get upcomingTasks => tasks.where((e) => e.date.contains('Des')).toList();
}