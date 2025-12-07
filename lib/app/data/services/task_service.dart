// Path: lib/app/data/services/task_service.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskService {
  // Simulasikan tanggal tugas di masa depan (misal tahun 2025)
  final List<TaskModel> _dummyDatabase = [
    TaskModel(
      id: '1',
      title: 'Design new ui presentation',
      project: 'RI Task',
      date: '7 Nov 2025', // Harus konsisten dengan parsing 'd MMM yyyy'
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
    // Tugas Tambahan (misal di bulan Desember 2025)
    TaskModel(
      id: '3',
      title: 'Final Project Submission',
      project: 'University',
      date: '10 Dec 2025',
      dateColor: Colors.purple,
      progressColor: Colors.blue,
      todos: [
        {'title': 'Write report', 'isCompleted': false},
      ],
    ),
  ];

  Future<List<TaskModel>> fetchTasks() async {
    await Future.delayed(const Duration(seconds: 2));
    return _dummyDatabase;
  }

  Future<bool> addTask(TaskModel task) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}