import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class HomeController extends GetxController {
  // 1. Ambil Controller Global
  final TaskController taskController = Get.find<TaskController>();

  // 2. Search Variable
  RxString searchQuery = ''.obs;

  // 3. Getter untuk Today Tasks (dengan filter search)
  RxList<TaskModel> get todayTasks {
    if (searchQuery.value.isEmpty) {
      return taskController.todayTasks;
    }
    final query = searchQuery.value.toLowerCase();
    final filtered = taskController.todayTasks
        .where((task) => task.title.toLowerCase().contains(query))
        .toList();
    return filtered.obs;
  }

  // 4. Getter untuk Upcoming Tasks (dengan filter search)
  RxList<TaskModel> get upcomingTasks {
    if (searchQuery.value.isEmpty) {
      return taskController.upcomingTasks;
    }
    final query = searchQuery.value.toLowerCase();
    final filtered = taskController.upcomingTasks
        .where((task) => task.title.toLowerCase().contains(query))
        .toList();
    return filtered.obs;
  }

  // 5. Method untuk update search query
  void updateSearch(String query) {
    searchQuery.value = query;
  }

  // 6. Method untuk clear search
  void clearSearch() {
    searchQuery.value = '';
  }
}
