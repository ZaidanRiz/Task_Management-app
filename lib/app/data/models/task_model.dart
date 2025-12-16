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

  int get progress => todos.where((t) => t['isCompleted'] == true).length;

  // Konversi ke Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'project': project,
      'date': date,
      'dateColor': dateColor.value,
      'progressColor': progressColor.value,
      'todos': todos,
    };
  }

  // Buat model dari Map (Firestore)
  static TaskModel fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: (map['id'] ?? '') as String,
      title: (map['title'] ?? '') as String,
      project: (map['project'] ?? '') as String,
      date: (map['date'] ?? '') as String,
      dateColor: Color((map['dateColor'] ?? Colors.red.value) as int),
      progressColor: Color((map['progressColor'] ?? Colors.green.value) as int),
      todos: (map['todos'] is List)
          ? List<Map<String, dynamic>>.from(
              (map['todos'] as List).map((e) => {
                    'title': (e as Map)['title'],
                    'isCompleted': (e as Map)['isCompleted'] ?? false,
                  }),
            )
          : <Map<String, dynamic>>[],
    );
  }
}
