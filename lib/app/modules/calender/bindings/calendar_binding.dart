import 'package:get/get.dart';
import '../controllers/calendar_controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    // Controller akan dibuat saat halaman Calendar dibuka
    Get.lazyPut<CalendarController>(
      () => CalendarController(),
    );
  }
}