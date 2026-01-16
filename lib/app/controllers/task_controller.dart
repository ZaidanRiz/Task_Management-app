  import 'package:get/get.dart';
  import 'package:intl/intl.dart';
  import '../data/models/task_model.dart';
  import '../data/services/task_service.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'auth_controller.dart';
  import 'dart:async';

  class TaskController extends GetxController {
    final TaskService _taskService = TaskService();
    final AuthController _auth = Get.find<AuthController>();

    var tasks = <TaskModel>[].obs;
    var isLoading = false.obs;

    var todayTasks = <TaskModel>[].obs;
    var upcomingTasks = <TaskModel>[].obs;

    String? _currentUid;
    StreamSubscription<List<TaskModel>>? _tasksSub;

    @override
    void onInit() {
      super.onInit();
      // Dengarkan perubahan user agar daftar tugas berganti sesuai akun aktif
      _auth.currentUser.listen((user) {
        _currentUid = user?.uid;
        if (_currentUid == null) {
          // Tidak ada user: bersihkan daftar agar tidak nyangkut ke akun sebelumnya
          _tasksSub?.cancel();
          tasks.clear();
          todayTasks.clear();
          upcomingTasks.clear();
          tasks.refresh();
          todayTasks.refresh();
          upcomingTasks.refresh();
        } else {
          _subscribeTasks();
        }
      });
      // Inisialisasi awal jika sudah ada user
      _currentUid = FirebaseAuth.instance.currentUser?.uid;
      if (_currentUid != null) {
        _subscribeTasks();
      }
    }

    void _subscribeTasks() {
      if (_currentUid == null) return;
      _tasksSub?.cancel();
      _tasksSub = _taskService.streamTasks(_currentUid!).listen((list) {
        tasks.assignAll(list);
        assignTaskCategories();
      });
    }

    void loadTasks() async {
      if (_currentUid == null) return;
      try {
        isLoading.value = true;
        var fetchedTasks = await _taskService.fetchTasks(_currentUid!);
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
    Future<void> addTask(TaskModel task) async {
      if (_currentUid == null) return; // Tidak ada user aktif
      final id = await _taskService.addTask(_currentUid!, task);
      if (task.id != id) {
        task.id = id;
      }
      tasks.add(task);
      assignTaskCategories();
    }

    void deleteTask(String id) {
      if (_currentUid == null) return;
      // Jaga konsistensi data di service, lalu perbarui list reaktif lokal
      _taskService.deleteTask(_currentUid!, id).then((_) {
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
        if (_currentUid != null) {
          // sinkronkan ke service
          _taskService.updateTask(_currentUid!, task);
        }
      }
    }
  }
