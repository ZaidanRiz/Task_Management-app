import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/task_model.dart';

class TaskController extends GetxController {
  // 1. List Global untuk menyimpan SEMUA tugas
  var tasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // 2. Isi data awal (Dummy Data) agar tidak kosong saat pertama buka
    tasks.addAll([
      TaskModel(
        title: 'Design new ui presentation',
        project: 'RI Task',
        progress: 10,
        total: 10,
        date: '7 Nov 2025',
        dateColor: Colors.red,
        progressColor: Colors.green,
      ),
      TaskModel(
        title: 'Add more ui/ux to mockups',
        project: 'PKPL Task',
        progress: 7,
        total: 10,
        date: '19 Nov 2025',
        dateColor: const Color(0xFFF7941D),
        progressColor: Colors.orange,
      ),
      TaskModel(
        title: 'Search Idea of Problems',
        project: 'RI Task',
        progress: 3,
        total: 10,
        date: '1 Des 2025',
        dateColor: const Color(0xFF6C63FF),
        progressColor: Colors.blue,
      ),
    ]);
  }

  // 3. Fungsi Menambah Tugas Baru
  void addTask(TaskModel task) {
    tasks.add(task);
    update(); // Memastikan semua UI yang menyimak ikut update
  }

  // 4. Helper: Ambil Tugas Hari Ini (Logic Sederhana berdasarkan string tanggal)
  // Catatan: Idealnya menggunakan DateTime, tapi kita pakai String dulu sesuai kode Anda
  List<TaskModel> get todayTasks {
    // Filter dummy: anggap tugas "19 Nov 2025" adalah hari ini
    return tasks.where((task) => task.date.contains('19 Nov')).toList();
  }

  // 5. Helper: Ambil Tugas Mendatang
  List<TaskModel> get upcomingTasks {
    return tasks.where((task) => !task.date.contains('19 Nov')).toList();
  }
}