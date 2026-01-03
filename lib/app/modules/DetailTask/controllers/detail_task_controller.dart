import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class DetailTaskController extends GetxController {
  // Ambil Global Controller
  final TaskController globalTaskController = Get.find<TaskController>();

  // Task yang sedang dilihat
  late TaskModel task;

  @override
  void onInit() {
    super.onInit();
    // Ambil data yang dikirim dari halaman sebelumnya
    task = Get.arguments as TaskModel;
  }

  // Fungsi Toggle (Langsung update ke Global)
  void toggleStep(int index) {
    globalTaskController.toggleTodo(task.id, index);
  }

  // Fungsi Delete
  void deleteTask() {
    Get.defaultDialog(
      title: "Delete Task",
      middleText: "Are you sure you want to delete this task?",
      textConfirm: "Yes",
      textCancel: "No",
      onConfirm: () {
        globalTaskController.deleteTask(task.id); // Hapus dari global
        Get.back(closeOverlays: false); // Tutup Dialog
        Get.back(closeOverlays: false); // Kembali ke halaman sebelumnya
        Get.snackbar("Deleted", "Task deleted successfully");
      },
    );
  }

  void editTask() {
    Get.snackbar("Info", "Fitur Edit akan datang di minggu depan");
  }
}
