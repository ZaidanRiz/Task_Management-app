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
        // Dukung beberapa format input tanggal (contoh: "07/12/2025" atau "7 Dec 2025")
        DateTime taskDate = _parseTaskDate(task.date);
        DateTime only = DateTime(taskDate.year, taskDate.month, taskDate.day);

        if (only.isAtSameMomentAs(todayDate)) {
          todayTasks.add(task);
        } else if (only.isAfter(todayDate)) {
          upcomingTasks.add(task);
        }
      } catch (e) {
        print("ERROR PARSE: ${task.date} -> $e");
      }
    }

    todayTasks.refresh();
    upcomingTasks.refresh();
  }

  // Coba beberapa format tanggal yang umum agar tidak gagal mengelompokkan tanpa terlihat
  DateTime _parseTaskDate(String raw) {
    final candidates = <DateFormat>[
      DateFormat("dd/MM/yyyy"), // contoh: 07/12/2025
      DateFormat("d/M/yyyy"), // contoh: 7/12/2025
      DateFormat("dd MMM yyyy"), // contoh: 07 Dec 2025
      DateFormat("d MMM yyyy"), // contoh: 7 Dec 2025
      DateFormat("d MMMM yyyy"), // contoh: 7 December 2025
    ];

    for (final fmt in candidates) {
      try {
        return fmt.parseStrict(raw);
      } catch (_) {
        // lanjut ke format berikutnya
      }
    }
    // Jika semua format gagal, coba DateTime.parse (format mirip ISO)
    try {
      return DateTime.parse(raw);
    } catch (_) {
      // Lempar ulang dengan konteks agar bisa ditangani pemanggil
      throw FormatException('Unsupported date format: $raw');
    }
  }

  // CREATE
  void addTask(TaskModel task) async {
    await _taskService.addTask(task);
    tasks.add(task);
    assignTaskCategories();
  }

  void deleteTask(String id) {
    // Jaga konsistensi data di service, lalu perbarui list reaktif lokal
    _taskService.deleteTask(id).then((_) {
      tasks.removeWhere((task) => task.id == id);
      assignTaskCategories();
    });
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
