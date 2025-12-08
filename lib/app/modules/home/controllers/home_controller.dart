import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class HomeController extends GetxController {
  // 1. Ambil Controller Global
  final TaskController taskController = Get.find<TaskController>();

  // 2. Getter untuk Today Tasks (kembalikan RxList agar Obx berlangganan perubahan)
  RxList<TaskModel> get todayTasks => taskController.todayTasks;

  // 3. Getter untuk Upcoming Tasks
  RxList<TaskModel> get upcomingTasks => taskController.upcomingTasks;
}
