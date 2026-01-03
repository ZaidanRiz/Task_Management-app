import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_task_controller.dart';

class DetailTaskView extends GetView<DetailTaskController> {
  const DetailTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(closeOverlays: false),
        ),
        title: Text(
          controller.task.project, // Judul Project Dinamis (misal: 'RI Task')
          style:
              const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () => controller.editTask(),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black),
            onPressed: () => controller.deleteTask(),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER JUDUL TUGAS ---
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                // Judul Tugas Dinamis (misal: 'Design new ui...')
                child: Text(
                  controller.task.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
            ),

            // --- LIST STEP (CHECKLIST) ---
            Expanded(
              child: Obx(() {
                // Mencari data tugas terbaru dari Global Controller agar reaktif
                // (Jika user mencentang, UI langsung berubah)
                var currentTask = controller.globalTaskController.tasks
                    .firstWhere((element) => element.id == controller.task.id,
                        orElse: () => controller.task);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  // Menggunakan 'todos' dari TaskModel
                  itemCount: currentTask.todos.length,
                  itemBuilder: (context, index) {
                    final step = currentTask.todos[index];
                    return _buildStepItem(
                      title: step['title'],
                      isCompleted: step['isCompleted'],
                      onTap: () => controller.toggleStep(index),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION BAR ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambah logika add step jika diperlukan nanti
        },
        backgroundColor: Colors.blue,
        elevation: 4.0,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // Widget Item Checklist Custom (Kotak Biru)
  Widget _buildStepItem(
      {required String title,
      required bool isCompleted,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: Colors.blue.withOpacity(0.5), // Warna Border Biru
              width: 1.5),
        ),
        child: Row(
          children: [
            // Custom Checkbox
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue, width: 1.5),
                color: isCompleted ? Colors.blue : Colors.transparent,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 15),
            // Teks Langkah
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : null, // Coret jika selesai
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Bottom Nav Bar
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
            // Home
            _buildNavItem(Icons.home, isSelected: false, routeName: '/home'),

            // Calendar
            _buildNavItem(Icons.calendar_month,
                isSelected: false, routeName: '/calendar'),

            const SizedBox(width: 40), // Spasi untuk FAB (+)

            // All Tasks (Description)
            _buildNavItem(Icons.description,
                isSelected: false, routeName: '/description'),

            // Settings
            _buildNavItem(Icons.settings,
                isSelected: false, routeName: '/settings'),
          ],
        ),
      ),
    );
  }

  // Widget Helper Item Navigasi
  Widget _buildNavItem(IconData icon,
      {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
        size: 24,
      ),
      onPressed: () {
        if (routeName != null) {
          // Menggunakan Get.offNamed agar halaman Detail ditutup
          Get.offNamed(routeName);
        }
      },
    );
  }
}
