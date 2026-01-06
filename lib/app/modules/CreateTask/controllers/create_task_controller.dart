import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';
import 'package:task_management_app/app/services/notification_service.dart';

class CreateTaskController extends GetxController {
  final TaskController globalTaskController = Get.find<TaskController>();

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final RxList<TextEditingController> stepControllers =
      <TextEditingController>[].obs;

  var isLoading = false.obs;
  var selectedDateTime = DateTime.now().obs;
  var selectedTime = const TimeOfDay(hour: 9, minute: 0).obs;

  final List<String> daysLabel = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];
  var selectedDays =
      <bool>[false, false, false, false, false, false, false].obs;

  void toggleDay(int index) {
    selectedDays[index] = !selectedDays[index];
  }

  @override
  void onInit() {
    super.onInit();
    stepControllers.add(TextEditingController());
    timeController.text = _formatTime(selectedTime.value);
  }

  void setSelectedDate(DateTime pickedDate) {
    selectedDateTime.value = pickedDate;
    final formattedDate = DateFormat('d MMM yyyy').format(pickedDate);
    dateController.text = formattedDate;
    debugPrint('[CreateTask] setSelectedDate: $formattedDate');
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime.value,
    );
    if (picked != null) {
      selectedTime.value = picked;
      timeController.text = _formatTime(picked);
      debugPrint('[CreateTask] pickTime: ${timeController.text}');
    }
  }

  String _formatTime(TimeOfDay tod) {
    final h = tod.hour.toString().padLeft(2, '0');
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void addStepField() {
    stepControllers.add(TextEditingController());
  }

  void removeStepField(int index) {
    if (stepControllers.length <= 1) return;
    final ctrl = stepControllers.removeAt(index);
    ctrl.dispose();
  }

  void submitTask() async {
    final List<Map<String, dynamic>> newTodos = stepControllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .map((t) => {'title': t, 'isCompleted': false})
        .toList();

    if (titleController.text.trim().isEmpty ||
        dateController.text.trim().isEmpty ||
        newTodos.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nama Tugas, minimal 1 Sub Task, dan Tanggal tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
      return;
    }

    isLoading.value = true;

    final newTask = TaskModel(
      id: DateTime.now().toString(),
      title: titleController.text,
      project: "Personal",
      date: dateController.text,
      dateColor: Colors.blue,
      progressColor: Colors.blue,
      todos: newTodos,
    );

    try {
      await globalTaskController.addTask(newTask);

      // LOG penting untuk debug
      debugPrint('[CreateTask] newTask.date = "${newTask.date}"');
      debugPrint(
          '[CreateTask] selectedTime = ${selectedTime.value.hour}:${selectedTime.value.minute}');

      try {
        final dueDate =
            DateFormat('d MMM yyyy').parseStrict(newTask.date.trim());
        debugPrint('[CreateTask] dueDate = $dueDate');

        final now = DateTime.now();
        DateTime oneTimeAt = DateTime(
          dueDate.year,
          dueDate.month,
          dueDate.day,
          selectedTime.value.hour,
          selectedTime.value.minute,
        );

        debugPrint('[CreateTask] oneTimeAt (before adjust) = $oneTimeAt');
        debugPrint('[CreateTask] now = $now');

        // Robustness:
        // - If the selected date is in the past => block.
        // - If date is today but time already passed => move to tomorrow at the same time.
        final startOfToday = DateTime(now.year, now.month, now.day);
        final startOfDue = DateTime(dueDate.year, dueDate.month, dueDate.day);
        if (startOfDue.isBefore(startOfToday)) {
          Get.snackbar(
            'Gagal',
            'Tanggal yang dipilih sudah lewat. Pilih tanggal hari ini atau setelahnya.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(10),
          );
          isLoading.value = false;
          return;
        }

        if (startOfDue.isAtSameMomentAs(startOfToday) &&
            oneTimeAt.isBefore(now.add(const Duration(seconds: 5)))) {
          oneTimeAt = oneTimeAt.add(const Duration(days: 1));
          debugPrint('[CreateTask] oneTimeAt moved to tomorrow = $oneTimeAt');
        }

        final oneTimeId = newTask.id.hashCode & 0x7fffffff;

        await NotificationService.instance.scheduleOneTimeSmart(
          id: oneTimeId,
          dateTime: oneTimeAt,
          title: 'Deadline: ${newTask.title}',
          body: 'Tugas jatuh tempo hari ini. Jangan lupa diselesaikan!',
        );

        // Weekly reminders (opsional)
        final weekdays = <int>[
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
          DateTime.saturday,
          DateTime.sunday,
        ];

        for (int i = 0; i < selectedDays.length; i++) {
          if (selectedDays[i]) {
            await NotificationService.instance.scheduleWeekly(
              id: (oneTimeId + i + 1) & 0x7fffffff,
              weekday: weekdays[i],
              timeOfDay: selectedTime.value,
              title: 'Reminder: ${newTask.title}',
              body: 'Pengingat mingguan untuk tugas ini.',
            );
          }
        }
      } catch (e, st) {
        debugPrint('Failed to schedule notification: $e');
        debugPrint('$st');
      }

      Get.snackbar(
        "Berhasil",
        "Task '${titleController.text}' berhasil ditambahkan!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 1),
      );

      // Battery-optimization guidance stays available in Settings.

      await Future.delayed(const Duration(milliseconds: 1200));

      globalTaskController.assignTaskCategories();
      Get.offNamed('/description');
    } catch (e) {
      final msg = e.toString();
      Get.snackbar(
        "Gagal",
        msg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    for (final c in stepControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
