import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/data/models/task_model.dart';

class CalendarController extends GetxController {
  // 1. Menemukan (Find) Controller Global
  final TaskController taskController = Get.find<TaskController>();

  // 2. State untuk tanggal yang dipilih (Highlight di UI Kalender)
  var selectedDay = 16.obs;

  // 3. Mengambil daftar tugas dari Global Controller
  // Saat global tasks bertambah (dari halaman Create Task), list ini otomatis terupdate
  List<TaskModel> get displayedTasks => taskController.tasks;

  // 4. Fungsi untuk mengubah tanggal yang dipilih
  void changeDate(int day) {
    selectedDay.value = day;
  }
}