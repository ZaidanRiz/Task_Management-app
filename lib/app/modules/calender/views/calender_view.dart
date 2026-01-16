// Path: lib/app/modules/calendar/views/calendar_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/app/utils/date_helper.dart';
import 'package:task_management_app/app/modules/home/widgets/task_card.dart'; 

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Calendar',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 1. Kalender Interaktif
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: _buildCalendarWidget(),
          ),

          // 2. Judul Tasks (Reaktif)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Obx(() => Text(
                  "Tasks on ${controller.selectedDay} ${_monthName(controller.selectedDate.value.month)} ${controller.selectedDate.value.year}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
          ),

          // 3. Daftar Tugas (Reaktif dengan Obx)
          Expanded(
            child: Obx(() {
              if (controller.displayedTasks.isEmpty) {
                return const Center(
                    child: Text("Tidak ada tugas terjadwal pada tanggal ini."));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: controller.displayedTasks.length,
                itemBuilder: (context, index) {
                  final task = controller.displayedTasks[index];
                  
                  // Hitung warna secara dinamis menggunakan Helper
                  final dynamicColor = DateHelper.getDeadlineColor(task.date);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: TaskCard(
                      title: task.title,
                      subtitle: task.project, 
                      date: task.date,
                      // Konversi progress int ke double (0.0 - 1.0)
                      progress: (task.total == 0) ? 0.0 : (task.progress / task.total),
                      progressText: "${task.progress}/${task.total}",
                      dateColor: dynamicColor,
                      onTap: () => Get.toNamed('/detail-task', arguments: task),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildCalendarWidget() {
    final List<String> daysOfWeek = ['MIN', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        children: [
          // Navigasi Bulan/Tahun
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 16, color: Colors.black54),
                    onPressed: () => controller.changeMonth(-1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                        '${_monthName(controller.selectedDate.value.month)} ${controller.selectedDate.value.year}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
                    onPressed: () => controller.changeMonth(1),
                  ),
                ],
              )),
          const SizedBox(height: 20),
          Table(
            children: [
              TableRow(
                children: daysOfWeek
                    .map((day) => Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(day,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  color: Colors.grey.shade600)),
                        )))
                    .toList(),
              ),
            ],
          ),

          // Grid Hari
          Obx(() {
            final daysOfMonth = controller.daysOfMonthGrid;
            final now = DateTime.now();

            return Table(
              border: TableBorder.all(color: Colors.transparent),
              children: List.generate((daysOfMonth.length / 7).ceil(), (row) {
                return TableRow(
                  children: List.generate(7, (col) {
                    final index = row * 7 + col;

                    if (index >= daysOfMonth.length || daysOfMonth[index] == 0) {
                      return const SizedBox(height: 30);
                    }

                    final day = daysOfMonth[index];
                    
                    bool isToday = day == now.day &&
                        controller.selectedDate.value.month == now.month &&
                        controller.selectedDate.value.year == now.year;

                    bool isSelected = day == controller.selectedDay;

                    return GestureDetector(
                      onTap: () => controller.changeDate(day),
                      child: Container(
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? Colors.blue : Colors.transparent,
                          border: isToday && !isSelected
                              ? Border.all(color: Colors.blue, width: 1)
                              : null,
                        ),
                        child: Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: isSelected
                                ? Colors.white
                                : (isToday ? Colors.blue : Colors.black87),
                            fontWeight: isSelected || isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            );
          })
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () => Get.toNamed('/create-task'),
      backgroundColor: Colors.blue,
      elevation: 4.0,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 30, color: Colors.white),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavItem(Icons.home, isSelected: false, routeName: '/home'),
            _buildNavItem(Icons.calendar_month, isSelected: true, routeName: '/calendar'),
            const SizedBox(width: 40),
            _buildNavItem(Icons.description, isSelected: false, routeName: '/description'),
            _buildNavItem(Icons.settings, isSelected: false, routeName: '/settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.blue : Colors.black54, size: 24),
      onPressed: () {
        if (routeName != null && !isSelected) Get.offNamed(routeName);
      },
    );
  }
}
