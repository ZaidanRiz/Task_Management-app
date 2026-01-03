import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/all_task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class AllTasksView extends GetView<AllTaskController> {
  const AllTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Tambahkan background agar bersih
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(closeOverlays: false),
        ),
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // --- HEADER TODAY ---
              _buildTaskHeader("Today's task"),

              // --- LIST TODAY ---
              Obx(() {
                if (controller.todayTasks.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("Tidak ada tugas hari ini.",
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return Column(
                  children: controller.todayTasks
                      .map((task) => _buildTaskCard(task))
                      .toList(),
                );
              }),

              const SizedBox(height: 20),

              // --- HEADER UPCOMING ---
              _buildTaskHeader("Upcoming task"),

              // --- LIST UPCOMING ---
              Obx(() {
                if (controller.upcomingTasks.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text("Tidak ada tugas mendatang.",
                          style: TextStyle(color: Colors.grey)),
                    ),
                  );
                }
                return Column(
                  children: controller.upcomingTasks
                      .map((task) => _buildTaskCard(task))
                      .toList(),
                );
              }),

              const SizedBox(height: 100), // Space untuk FAB
            ],
          ),
        ),
      ),

      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () async {
        // 1. Tunggu user kembali dari halaman create
        await Get.toNamed('/create-task');

        // 2. Refresh data saat kembali
        controller.refreshTasks();
      },
      backgroundColor: Colors.blue,
      elevation: 4.0,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 30, color: Colors.white),
    );
  }

  Widget _buildTaskHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      onTap: () {
        Get.toNamed('/detail-task', arguments: task);
      },
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
            _buildNavItem(Icons.calendar_month,
                isSelected: false, routeName: '/calendar'),
            const SizedBox(width: 40), // Space untuk FAB di tengah
            _buildNavItem(Icons.description,
                isSelected: true, routeName: '/description'),
            _buildNavItem(Icons.settings,
                isSelected: false, routeName: '/settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon,
      {bool isSelected = false, String? routeName}) {
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

// --- CLASS TASK CARD (Agar tidak error "Undefined name TaskCard") ---
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
            BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 5),
            Text(project,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            const SizedBox(height: 15),
            Row(
              children: <Widget>[
                const Icon(Icons.list_alt, size: 14, color: Colors.grey),
                const SizedBox(width: 5),
                const Text('Progress',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                Text('$progress/$total',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: dateColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(date,
                  style: TextStyle(
                      color: dateColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }
}
