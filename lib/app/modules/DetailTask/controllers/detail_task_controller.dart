import 'package:get/get.dart';

class DetailTaskController extends GetxController {
  // Data dummy untuk langkah-langkah (Nanti bisa diambil dari API/Arguments)
  // Menggunakan RxList agar UI otomatis update saat dicentang
  var steps = <Map<String, dynamic>>[
    {'title': '#1 Search References', 'isCompleted': false},
    {'title': '#2 Search Components', 'isCompleted': false},
    {'title': '#3 Create Wireframe', 'isCompleted': false},
    {'title': '#4 Define Color Palette & Typography', 'isCompleted': false},
    {'title': '#5 Design Key Screens', 'isCompleted': false},
    {'title': '#6 Add Interaction / Prototype in Figma', 'isCompleted': false},
    {'title': '#7 Review & Feedback', 'isCompleted': false},
    {'title': '#8 Revise & Improve Based on Feedback', 'isCompleted': false},
    {'title': '#9 Finalize UI Kit', 'isCompleted': false},
    {'title': '#10 Export & Prepare Presentation Deck', 'isCompleted': false},
  ].obs;

  // Fungsi untuk mengubah status checklist
  void toggleStep(int index) {
    var step = steps[index];
    step['isCompleted'] = !step['isCompleted'];
    steps[index] = step; // Trigger update UI
  }

  // Fungsi Edit (Dummy)
  void editTask() {
    Get.snackbar("Edit", "Fitur Edit diklik");
  }

  // Fungsi Delete (Dummy)
  void deleteTask() {
    Get.defaultDialog(
      title: "Delete Task",
      middleText: "Are you sure you want to delete this task?",
      textConfirm: "Yes",
      textCancel: "No",
      onConfirm: () {
        Get.back(); // Tutup dialog
        Get.back(); // Kembali ke halaman sebelumnya
        Get.snackbar("Deleted", "Task deleted successfully");
      },
    );
  }
}