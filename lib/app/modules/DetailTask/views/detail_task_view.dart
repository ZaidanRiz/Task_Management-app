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
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'RI Task', // Judul Project (Sesuai Gambar)
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Design new ui presentation",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.black87
                  ),
                ),
              ),
            ),

            // --- LIST STEP (CHECKLIST) ---
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: controller.steps.length,
                itemBuilder: (context, index) {
                  final step = controller.steps[index];
                  return _buildStepItem(
                    title: step['title'], 
                    isCompleted: step['isCompleted'],
                    onTap: () => controller.toggleStep(index),
                  );
                },
              )),
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION BAR (Sesuai Gambar) ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Logika tambah step jika perlu
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
  Widget _buildStepItem({required String title, required bool isCompleted, required VoidCallback onTap}) {
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
            width: 1.5
          ),
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
                  decoration: isCompleted ? TextDecoration.lineThrough : null, // Coret jika selesai
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Bottom Nav Bar (Dummy Visual Saja)
  Widget _buildBottomNavBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home, color: Colors.black54), onPressed: (){}),
            IconButton(icon: const Icon(Icons.chat_bubble_outline, color: Colors.black54), onPressed: (){}),
            const SizedBox(width: 40),
            IconButton(icon: const Icon(Icons.description_outlined, color: Colors.black54), onPressed: (){}),
            IconButton(icon: const Icon(Icons.settings_outlined, color: Colors.black54), onPressed: (){}),
          ],
        ),
      ),
    );
  }
}