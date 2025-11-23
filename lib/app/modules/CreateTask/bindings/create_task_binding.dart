import 'package:get/get.dart';
import '../controllers/create_task_controller.dart';

class CreateTaskBinding extends Bindings {
  @override
  void dependencies() {
    // LazyPut: Controller hanya akan dibuat saat View membutuhkan, hemat memori.
    Get.lazyPut<CreateTaskController>(
      () => CreateTaskController(),
    );
  }
} 