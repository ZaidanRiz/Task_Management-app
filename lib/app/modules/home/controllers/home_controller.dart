import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class HomeController extends GetxController {
  // 1. Ambil Controller Global
  final TaskController taskController = Get.find<TaskController>();

  // 2. Getter untuk Today Tasks (Otomatis update karena Rx)
  List<TaskModel> get todayTasks => taskController.todayTasks;

  // 3. Getter untuk Upcoming Tasks
  List<TaskModel> get upcomingTasks => taskController.upcomingTasks;
}