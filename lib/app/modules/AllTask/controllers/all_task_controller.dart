import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class AllTaskController extends GetxController {
  // 1. Menemukan (Find) Controller Global yang sudah dipasang di main.dart
  // Controller ini menyimpan data pusat ("Database Sementara")
  final TaskController taskController = Get.find<TaskController>();

  // 2. Getter untuk mengambil data 'todayTasks' dari Global Controller
  // Menggunakan RxList agar jika data global berubah, View di sini ikut update
  List<TaskModel> get todayTasks => taskController.todayTasks;

  // 3. Getter untuk mengambil data 'upcomingTasks' dari Global Controller
  List<TaskModel> get upcomingTasks => taskController.upcomingTasks;
}