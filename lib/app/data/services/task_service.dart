import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskService {
  // Ini adalah simulasi database di server
  final List<TaskModel> _dummyDatabase = [
    TaskModel(
      id: '1',
      title: 'Design new ui presentation',
      project: 'RI Task',
      date: '7 Nov 2025',
      dateColor: Colors.red,
      progressColor: Colors.green,
      todos: [
        {'title': 'Search References', 'isCompleted': true},
        {'title': 'Create Wireframe', 'isCompleted': false},
        {'title': 'Finalize Design', 'isCompleted': false},
      ],
    ),
    TaskModel(
      id: '2',
      title: 'Add more ui/ux to mockups',
      project: 'PKPL Task',
      date: '19 Nov 2025',
      dateColor: const Color(0xFFF7941D),
      progressColor: Colors.orange,
      todos: [
        {'title': 'Sketching', 'isCompleted': true},
        {'title': 'Prototyping', 'isCompleted': true},
      ],
    ),
  ];

  // FUNGSI GET (READ) - Simulasi ambil data dari API
  Future<List<TaskModel>> fetchTasks() async {
    // Simulasi delay jaringan (tunggu 2 detik seolah-olah download data)
    await Future.delayed(const Duration(seconds: 2));
    
    // Kembalikan data
    return _dummyDatabase;
  }

  // FUNGSI POST (CREATE) - Simulasi kirim data ke API
  Future<bool> addTask(TaskModel task) async {
    await Future.delayed(const Duration(seconds: 1));
    // Di backend asli, di sini kita kirim HTTP POST
    return true; // Berhasil
  }
}