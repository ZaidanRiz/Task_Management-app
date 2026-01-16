import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static Color getDeadlineColor(String dateString) {
    try {
      DateFormat format = DateFormat('d MMM yyyy');
      DateTime deadline = format.parse(dateString);
      DateTime now = DateTime.now();
      
      // Normalisasi ke jam 00:00:00
      DateTime today = DateTime(now.year, now.month, now.day);
      int difference = deadline.difference(today).inDays;

      if (difference <= 3) {
        return Colors.red;        // Deadline <= 3 hari
      } else if (difference <= 7) {
        return Colors.orange;     // Deadline <= 7 hari (1 minggu)
      } else {
        return Colors.green;      // Deadline > 1 minggu
      }
    } catch (e) {
      return Colors.blue;         // Warna default jika gagal parsing
    }
  }
}