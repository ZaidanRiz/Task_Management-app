import 'package:flutter/material.dart';

class TaskModel {
  String id; // Tambah ID agar mudah dihapus/diedit
  String title;
  String project;
  String date;
  Color dateColor;
  Color progressColor;
  List<Map<String, dynamic>> todos; // Menyimpan langkah-langkah

  


  TaskModel({
    required this.id,
    required this.title,
    required this.project,
    required this.date,
    required this.dateColor,
    required this.progressColor,
    this.todos = const [], // Default kosong
  });

  // Getter dinamis untuk menghitung progress & total
  int get total => todos.length;
  int get progress => todos.where((e) => e['isCompleted'] == true).length;
}