import 'package:flutter/material.dart';
import 'package:get/get.dart'; // 1. Import GetX

class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String date;
  final double progress;
  final String progressText;
  
  // Opsional: Tambahkan callback jika ingin custom navigasi dari luar
  final VoidCallback? onTap; 

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.progress,
    required this.progressText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 2. Bungkus dengan InkWell/GestureDetector untuk interaksi
    return GestureDetector(
      onTap: onTap ?? () {
        // Default Action jika tidak ada onTap khusus:
        // Misalnya masuk ke detail task
        // Get.toNamed('/task-detail', arguments: {'title': title});
        
        Get.snackbar(
          "Task Clicked", 
          "You clicked on $title",
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 1),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade100, width: 1),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                
                // 3. Tombol Opsi dengan Get.bottomSheet
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    _showOptionsInternal();
                  },
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.list, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                const Text("Progress", style: TextStyle(color: Colors.grey)),
                const Spacer(),
                Text(progressText, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              color: Colors.orange,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                date,
                style: TextStyle(color: Colors.yellow.shade900, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan BottomSheet GetX
  void _showOptionsInternal() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, 
              height: 4, 
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blue),
              title: const Text("Edit Task"),
              onTap: () {
                Get.back(); // Tutup bottom sheet
                Get.toNamed('/create-task'); // Contoh navigasi ke edit
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text("Delete Task"),
              onTap: () {
                Get.back(); // Tutup bottom sheet
                // Tampilkan Dialog Konfirmasi Hapus
                Get.defaultDialog(
                  title: "Delete Task",
                  middleText: "Are you sure you want to delete '$title'?",
                  textCancel: "Cancel",
                  textConfirm: "Delete",
                  confirmTextColor: Colors.white,
                  buttonColor: Colors.red,
                  onConfirm: () {
                    Get.back(); // Tutup dialog
                    Get.snackbar("Deleted", "Task has been deleted", backgroundColor: Colors.red.withOpacity(0.2));
                  }
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}