// lib/app/data/services/task_service.dart
import 'package:task_management_app/app/data/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskService {
  // Simpel in-memory storage; ganti dengan API / local DB sesuai kebutuhan
  final List<TaskModel> _store = [
    // contoh data (opsional)
    TaskModel(
      id: '1',
      title: 'Design new ui presentation',
      project: 'RI Task',
      date: '7 Nov 2025',
      dateColor: Colors.red,
      progressColor: Colors.green,
      todos: [
        {'title': 'Draft', 'isCompleted': true},
        {'title': 'Review', 'isCompleted': false},
        {'title': 'Finalize', 'isCompleted': false},
      ],
    ),
    TaskModel(
      id: '2',
      title: 'Add more ui/ux to mockups',
      project: 'PKPL Task',
      date: '19 Nov 2025',
      dateColor: Colors.orange,
      progressColor: Colors.orange,
      todos: [
        {'title': 'Mockup 1', 'isCompleted': true},
        {'title': 'Mockup 2', 'isCompleted': true},
      ],
    ),
  ];

  Future<List<TaskModel>> fetchTasks() async {
    // Simulasi delay seperti network / DB
    await Future.delayed(const Duration(milliseconds: 300));
    return List<TaskModel>.from(_store);
  }

  Future<void> addTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 150));
    _store.add(task);
  }

  Future<void> deleteTask(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _store.removeWhere((t) => t.id == id);
  }

  // update toggle todo
  Future<void> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 100));
    var idx = _store.indexWhere((t) => t.id == task.id);
    if (idx != -1) _store[idx] = task;
  }
}
