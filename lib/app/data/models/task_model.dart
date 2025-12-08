import 'package:flutter/material.dart';

class TaskModel {
  String id;
  String title;
  String project;
  String date;
  Color dateColor;
  Color progressColor;
  List<Map<String, dynamic>> todos;

  TaskModel({
    required this.id,
    required this.title,
    required this.project,
    required this.date,
    required this.dateColor,
    required this.progressColor,
    required this.todos,
  });

  int get total => todos.length;

  int get progress =>
      todos.where((t) => t['isCompleted'] == true).length;
}
