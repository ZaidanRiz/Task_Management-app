import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../data/models/task_model.dart';
import '../data/services/task_service.dart';

class TaskController extends GetxController {
  final TaskService _taskService = TaskService();

  var tasks = <TaskModel>[].obs;
  var isLoading = false.obs;

  var todayTasks = <TaskModel>[].obs;
  var upcomingTasks = <TaskModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  void loadTasks() async {
    try {
      isLoading.value = true;
      var fetchedTasks = await _taskService.fetchTasks();
      tasks.assignAll(fetchedTasks);

      assignTaskCategories();
    } finally {
      isLoading.value = false;
    }
  }

  // FIXED: KATEGORI TODAY & UPCOMING
  void assignTaskCategories() {
    todayTasks.clear();
    upcomingTasks.clear();

    DateTime now = DateTime.now();
    DateTime todayDate = DateTime(now.year, now.month, now.day);

    for (var task in tasks) {
      try {
        DateTime taskDate = DateFormat("dd/MM/yyyy").parse(task.date);
        DateTime only = DateTime(taskDate.year, taskDate.month, taskDate.day);

        if (only.isAtSameMomentAs(todayDate)) {
          todayTasks.add(task);
        } else if (only.isAfter(todayDate)) {
          upcomingTasks.add(task);
        }
      } catch (e) {
        print("ERROR PARSE: ${task.date}");
      }
    }

    todayTasks.refresh();
    upcomingTasks.refresh();
  }

  // CREATE
  void addTask(TaskModel task) async {
    await _taskService.addTask(task);
    tasks.add(task);
    assignTaskCategories();
  }

  void deleteTask(String id) {
    tasks.removeWhere((task) => task.id == id);
    assignTaskCategories();
  }

  void toggleTodo(String taskId, int index) {
    int i = tasks.indexWhere((t) => t.id == taskId);
    if (i != -1) {
      var task = tasks[i];
      task.todos[index]['isCompleted'] = !task.todos[index]['isCompleted'];
      tasks[i] = task;
      tasks.refresh();
      assignTaskCategories();
    }
  }
}
