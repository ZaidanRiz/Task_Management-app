import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart'; // Pastikan import model ini ada

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // --- SEARCH BAR ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for Tasks",
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // --- CATEGORIES ---
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCategoryCard(
                    Icons.checklist, 
                    "To Do List", 
                    Colors.blue,
                    onTap: () => Get.toNamed('/description'),
                  ),
                  _buildCategoryCard(Icons.lightbulb, "AI Assistant", Colors.yellow),
                ],
              ),
              const SizedBox(height: 20),

              // --- TODAY'S TASK (DYNAMIS) ---
              const Text("Today's task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              // Menggunakan Obx agar update otomatis
              Obx(() {
                if (controller.todayTasks.isEmpty) {
                  return const Text("No tasks for today", style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children: controller.todayTasks.map((task) => _buildTaskCard(task)).toList(),
                );
              }),

              const SizedBox(height: 20),

              // --- UPCOMING TASK (DYNAMIS) ---
              const Text("Upcoming task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              
              Obx(() {
                if (controller.upcomingTasks.isEmpty) {
                  return const Text("No upcoming tasks", style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children: controller.upcomingTasks.map((task) => _buildTaskCard(task)).toList(),
                );
              }),
              
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      
      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/create-task'),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // BOTTOM NAV BAR
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Colors.blue)), // Aktif
              IconButton(onPressed: () => Get.toNamed('/calendar'), icon: const Icon(Icons.calendar_month, color: Colors.grey)),
              const SizedBox(width: 40),
              IconButton(onPressed: () => Get.toNamed('/description'), icon: const Icon(Icons.description, color: Colors.grey)),
              IconButton(onPressed: () => Get.toNamed('/settings'), icon: const Icon(Icons.settings, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildCategoryCard(IconData icon, String title, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return TaskCard(
      title: task.title,
      project: task.project,
      progress: task.progress,
      total: task.total,
      date: task.date,
      dateColor: task.dateColor,
      progressColor: task.progressColor,
      onTap: () => Get.toNamed('/detail-task'),
    );
  }
}

// --- CLASS TASK CARD (Disamakan dengan halaman lain agar konsisten) ---
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