import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
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

          // 2. Judul
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              "Today's task",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // 3. Daftar Tugas (Reaktif dengan Obx)
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.displayedTasks.length,
              itemBuilder: (context, index) {
                final task = controller.displayedTasks[index];
                
                return TaskCard( 
                  title: task.title,           // Akses Property Model
                  project: task.project,
                  progress: task.progress,
                  total: task.total,
                  date: task.date,
                  dateColor: task.dateColor,
                  progressColor: task.progressColor,
                  onTap: () => Get.toNamed('/detail-task', arguments: task),
                );
              },
            )),
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
    final List<String> daysOfWeek = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    final List<int> daysOfMonth = [0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 0, 0, 0, 0]; 

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.arrow_back_ios, size: 16, color: Colors.black54),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('30 October 2025', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black54),
            ],
          ),
          const SizedBox(height: 20),
          Table(
            children: [
              TableRow(
                children: daysOfWeek.map((day) => Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(day, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey.shade600)),
                  ),
                )).toList(),
              ),
            ],
          ),
          
          Obx(() => Table(
            border: TableBorder.all(color: Colors.transparent),
            children: List.generate((daysOfMonth.length / 7).ceil(), (row) {
              return TableRow(
                children: List.generate(7, (col) {
                  final index = row * 7 + col;
                  if (index >= daysOfMonth.length || daysOfMonth[index] == 0) {
                    return Container(height: 30); 
                  }
                  
                  final day = daysOfMonth[index];
                  bool isSelected = day == controller.selectedDay.value;
                  
                  return GestureDetector( 
                    onTap: () => controller.changeDate(day),
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.blue : Colors.transparent,
                      ),
                      child: Text(
                        day.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          )),
        ],
      ),
    );
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
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
        size: 24,
      ),
      onPressed: () {
        if (routeName != null && !isSelected) {
          Get.offNamed(routeName);
        }
      },
    );
  }
}

// --- TASK CARD WIDGET ---
class TaskCard extends StatelessWidget {
  final String title;
  final String project;
  final int progress;
  final int total;
  final String date;
  final Color dateColor;
  final Color progressColor;
  final VoidCallback? onTap;

  const TaskCard({
    required this.title,
    required this.project,
    required this.progress,
    required this.total,
    required this.date,
    required this.dateColor,
    required this.progressColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercentage = (total == 0) ? 0 : (progress / total);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: dateColor.withOpacity(0.4), width: 1), 
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.15), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 5),
            Text(project, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
                const Icon(Icons.list_alt, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                const Text('Progress', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(width: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressPercentage,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('$progress/$total', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: dateColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(date, style: TextStyle(color: dateColor, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}