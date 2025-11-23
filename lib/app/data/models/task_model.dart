import 'package:flutter/material.dart';

class TaskModel {
  String title;
  String project;
  int progress; // misal: 7
  int total;    // misal: 10
  String date;  // misal: "19 Nov 2025"
  Color dateColor;
  Color progressColor;

  TaskModel({
    required this.title,
    required this.project,
    required this.progress,
    required this.total,
    required this.date,
    required this.dateColor,
    required this.progressColor,
  });
}