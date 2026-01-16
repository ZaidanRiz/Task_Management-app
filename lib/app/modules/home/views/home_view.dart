import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';
import 'package:task_management_app/app/modules/home/widgets/task_card.dart'; 
import 'package:task_management_app/app/utils/date_helper.dart'; // Pastikan Helper ini ada

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

              // --- SEARCH BAR (Ditambahkan Obx untuk suffixIcon) ---
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Obx(() => TextField(
                  onChanged: (value) => controller.updateSearch(value),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for Tasks",
                    icon: const Icon(Icons.search),
                    suffixIcon: controller.searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => controller.clearSearch(),
                          )
                        : null,
                  ),
                )),
              ),
              const SizedBox(height: 30),

              // --- CATEGORIES ---
              const Text("Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  _buildCategoryCard(
                    Icons.lightbulb,
                    "AI Assistant",
                    Colors.yellow,
                    onTap: () => Get.toNamed('/ai-assistant'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- TODAY'S TASK (DYNAMIS) ---
              const Text("Today's task",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              Obx(() {
                if (controller.taskController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.todayTasks.isEmpty) {
                  return const Text("No tasks for today",
                      style: TextStyle(color: Colors.grey));
                }

                return Column(
                  children: controller.todayTasks
                      .map((task) => _buildTaskItem(task))
                      .toList(),
                );
              }),

              const SizedBox(height: 20),

              // --- UPCOMING TASK (DYNAMIS) ---
              const Text("Upcoming task",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),

              Obx(() {
                if (controller.upcomingTasks.isEmpty) {
                  return const Text("No upcoming tasks",
                      style: TextStyle(color: Colors.grey));
                }
                return Column(
                  children: controller.upcomingTasks
                      .map((task) => _buildTaskItem(task))
                      .toList(),
                );
              }),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/create-task'),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.home, color: Colors.blue)),
            IconButton(
                onPressed: () => Get.toNamed('/calendar'),
                icon: const Icon(Icons.calendar_month, color: Colors.grey)),
            const SizedBox(width: 40),
            IconButton(
                onPressed: () => Get.toNamed('/description'),
                icon: const Icon(Icons.description, color: Colors.grey)),
            IconButton(
                onPressed: () => Get.toNamed('/settings'),
                icon: const Icon(Icons.settings, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---

  // Gunakan nama ini untuk menghindari konflik dengan nama Class TaskCard
  Widget _buildTaskItem(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TaskCard(
        title: task.title,
        subtitle: task.project,
        date: task.date,
        // Menghitung progress dari data int (progress/total)
        progress: (task.total == 0) ? 0 : (task.progress / task.total),
        progressText: "${task.progress}/${task.total}",
        // Gunakan Helper untuk warna otomatis
        dateColor: DateHelper.getDeadlineColor(task.date),
        onTap: () => Get.toNamed('/detail-task', arguments: task),
      ),
    );
  }

  Widget _buildCategoryCard(IconData icon, String title, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                spreadRadius: 1)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}