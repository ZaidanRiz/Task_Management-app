// lib/app/modules/AllTask/views/all_task_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/all_task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';
import 'package:task_management_app/app/utils/date_helper.dart'; 
import 'package:task_management_app/app/modules/home/widgets/task_card.dart'; 

class AllTasksView extends GetView<AllTaskController> {
  const AllTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // Menggunakan SafeArea untuk memastikan tidak menabrak status bar/notch
      body: SafeArea(
        child: SingleChildScrollView(
          // Menambahkan physics agar scroll lebih smooth
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildTaskHeader("Today's task"),
              
              Obx(() {
                if (controller.todayTasks.isEmpty) {
                  return _buildEmptyState("Tidak ada tugas hari ini.");
                }
                return Column(
                  children: controller.todayTasks
                      .map((task) => _buildTaskItem(task))
                      .toList(),
                );
              }),

              const SizedBox(height: 20),
              _buildTaskHeader("Upcoming task"),

              Obx(() {
                if (controller.upcomingTasks.isEmpty) {
                  return _buildEmptyState("Tidak ada tugas mendatang.");
                }
                return Column(
                  children: controller.upcomingTasks
                      .map((task) => _buildTaskItem(task))
                      .toList(),
                );
              }),

              // --- SOLUSI OVERFLOW ---
              // Memberikan jarak ekstra di bawah agar konten tidak tertutup FAB
              const SizedBox(height: 120), 
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(message, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }

  Widget _buildTaskHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15), // Jarak antar kartu
      child: TaskCard(
        title: task.title,
        subtitle: task.project,
        date: task.date,
        progress: (task.total == 0) ? 0.0 : (task.progress / task.total),
        progressText: "${task.progress}/${task.total}",
        dateColor: DateHelper.getDeadlineColor(task.date), 
        onTap: () => Get.toNamed('/detail-task', arguments: task),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () async {
        await Get.toNamed('/create-task');
        controller.refreshTasks();
      },
      backgroundColor: Colors.blue,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 30, color: Colors.white),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, routeName: '/home'),
          _buildNavItem(Icons.calendar_month, routeName: '/calendar'),
          const SizedBox(width: 40),
          _buildNavItem(Icons.description, isSelected: true, routeName: '/description'),
          _buildNavItem(Icons.settings, routeName: '/settings'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(icon, color: isSelected ? Colors.blue : Colors.black54),
      onPressed: () {
        if (routeName != null && !isSelected) Get.offNamed(routeName);
      },
    );
  }
}