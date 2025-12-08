import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class AllTaskController extends GetxController {
  // 1. Temukan Controller Global
  final TaskController taskController = Get.find<TaskController>();

  // 2. Gunakan RxList (Wajib untuk Obx)
  // Kita nge-bridge (menjembatani) data dari Global ke View ini
  RxList<TaskModel> get todayTasks => taskController.todayTasks;
  RxList<TaskModel> get upcomingTasks => taskController.upcomingTasks;

  // 3. Fungsi Refresh (Memanggil logika di Global)
  void refreshTasks() {
    taskController.assignTaskCategories();
  }
}