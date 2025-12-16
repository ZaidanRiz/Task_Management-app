import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Controller profil sederhana untuk menyimpan data profil di memori aplikasi
// (nama & tanggal lahir). Nama juga akan disinkronkan ke FirebaseAuth.displayName
// saat disimpan dari EditProfile.
class ProfileController extends GetxController {
  final name = ''.obs; // Nama tampilan pengguna
  final birthDate = ''.obs; // Tanggal lahir dalam format dd-MM-yyyy

  @override
  void onInit() {
    super.onInit();
    final auth = FirebaseAuth.instance;
    // Inisialisasi awal dari akun aktif
    final user = auth.currentUser;
    name.value = user?.displayName ?? 'User';
    // Default tanggal lahir (jika belum pernah diisi)
    if (birthDate.value.isEmpty) birthDate.value = '24-11-2025';

    // Dengarkan perubahan auth (sign in/out/switch)
    auth.authStateChanges().listen((u) {
      if (u == null) {
        // Reset ke default saat logout
        name.value = 'User';
        birthDate.value = '24-11-2025';
      } else {
        // Saat user berganti, sinkronkan nama tampilan
        name.value = u.displayName ?? 'User';
      }
    });
  }
}
