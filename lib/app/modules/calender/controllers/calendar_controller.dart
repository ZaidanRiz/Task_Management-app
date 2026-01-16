// Path: lib/app/controllers/calendar_controller.dart

import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart'; 
import 'package:task_management_app/app/data/models/task_model.dart';
import 'package:intl/intl.dart'; 
import 'package:flutter/material.dart'; // Wajib ada untuk DateTime dan penggunaan warna jika ada

class CalendarController extends GetxController {
  // Asumsi TaskController global sudah ada dan menyimpan daftar tugas:
  final TaskController taskController = Get.find<TaskController>();

  // START PERBAIKAN: Set tanggal default ke tanggal dummy data (7 Nov 2025)
  // Ini memastikan tugas akan muncul saat aplikasi dibuka.
  var selectedDate = DateTime.now().obs;
  // END PERBAIKAN

  // Getter untuk mendapatkan nilai hari yang dipilih (untuk highlight UI)
  int get selectedDay => selectedDate.value.day;

  // Getter yang difilter (untuk ditampilkan di ListView)
  List<TaskModel> get displayedTasks {
    final selected = selectedDate.value;
    
    // Perhatikan penggunaan .where() yang aman di dalam Obx/Getter
    return taskController.tasks.where((task) {
        try {
            // Asumsi format di TaskModel adalah 'd MMM yyyy' (contoh: '7 Nov 2025')
            final taskDate = DateFormat('d MMM yyyy').parse(task.date);
            
            // Kita hanya perlu komponen Tanggal/Bulan/Tahun dari selectedDate
            final selectedDateOnly = DateTime(selected.year, selected.month, selected.day);

            // Bandingkan hanya Tahun, Bulan, dan Hari
            return taskDate.year == selectedDateOnly.year &&
                   taskDate.month == selectedDateOnly.month &&
                   taskDate.day == selectedDateOnly.day;
        } catch (e) {
            // Jika parsing gagal, abaikan tugas
            return false; 
        }
    }).toList();
  }
  
  // --- LOGIKA KALENDER DINAMIS ---
  
  int get _daysInMonth {
    final date = selectedDate.value;
    return DateTime(date.year, date.month + 1, 0).day;
  }
  
  int get _startDayIndex {
    final date = selectedDate.value;
    final firstDay = DateTime(date.year, date.month, 1);
    return firstDay.weekday % 7;
  }

  List<int> get daysOfMonthGrid {
    final days = _daysInMonth;
    final startDay = _startDayIndex;
    final List<int> grid = [];
    
    for (int i = 0; i < startDay; i++) {
      grid.add(0);
    }
    
    for (int i = 1; i <= days; i++) {
      grid.add(i);
    }
    return grid;
  }
  // --- END LOGIKA KALENDER DINAMIS ---

  // Fungsi untuk mengubah tanggal yang dipilih
  void changeDate(int day) {
    if (day == 0) return; 
    
    selectedDate.value = DateTime(selectedDate.value.year, selectedDate.value.month, day);
  }
  
  // Logika jika ingin mengubah bulan/tahun
  void changeMonth(int offset) {
    final newDate = DateTime(
      selectedDate.value.year,
      selectedDate.value.month + offset,
      1, 
    );
    
    selectedDate.value = DateTime(newDate.year, newDate.month, 1);
  }
}