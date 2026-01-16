import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/auth_controller.dart'; // Import AuthController

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Memastikan AuthController sudah diinisialisasi
    Get.lazyPut<AuthController>(() => AuthController());
  }
}