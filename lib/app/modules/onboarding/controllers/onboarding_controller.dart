import 'package:get/get.dart';

class OnboardingController extends GetxController {
  
  // Fungsi navigasi ke halaman Login
  void goToLogin() {
    // Menggunakan offNamed agar user tidak bisa kembali (Back) ke onboarding
    Get.offNamed('/login'); 
  }
}