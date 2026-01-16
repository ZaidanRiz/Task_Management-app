// lib/app/controllers/profile_controller.dart

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileController extends GetxController {
  final name = ''.obs;
  final birthDate = ''.obs;
  // --- TAMBAHKAN INI ---
  final photoUrl = ''.obs; 

  @override
  void onInit() {
    super.onInit();
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    
    // Inisialisasi awal
    name.value = user?.displayName ?? 'User';
    photoUrl.value = user?.photoURL ?? ''; // Ambil foto dari Firebase Auth
    
    if (birthDate.value.isEmpty) birthDate.value = '24-11-2025';

    auth.authStateChanges().listen((u) {
      if (u == null) {
        name.value = 'User';
        birthDate.value = '24-11-2025';
        photoUrl.value = ''; // Reset foto saat logout
      } else {
        name.value = u.displayName ?? 'User';
        photoUrl.value = u.photoURL ?? ''; // Update foto saat user berganti
      }
    });
  }
}