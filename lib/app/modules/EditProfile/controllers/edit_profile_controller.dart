import 'dart:io'; // Import untuk File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileController extends GetxController {
  // Controller TextFields
  final nameController = TextEditingController();
  final dateController = TextEditingController();

  // Variabel untuk menyimpan File Gambar
  Rx<File?> profileImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi dari ProfileController (reactive state di memori)
    final profile = Get.find<ProfileController>();
    nameController.text = profile.name.value.isNotEmpty
        ? profile.name.value
        : (FirebaseAuth.instance.currentUser?.displayName ?? '');
    dateController.text = profile.birthDate.value.isNotEmpty
        ? profile.birthDate.value
        : "24-11-2025";
  }

  // --- LOGIKA AMBIL GAMBAR ---
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil gambar: $e");
    }
  }

  // --- LOGIKA PILIH TANGGAL ---
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format tanggal menjadi DD-MM-YYYY
      dateController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  // --- SIMPAN PROFIL ---
  Future<void> saveProfile() async {
    final profile = Get.find<ProfileController>();
    final newName = nameController.text.trim();
    final newDob = dateController.text.trim();

    try {
      // 1) Update FirebaseAuth.displayName (jika user ada)
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && newName.isNotEmpty) {
        await user.updateDisplayName(newName);
      }

      // 2) Simpan ke state lokal (agar Settings langsung merefleksikan perubahan)
      if (newName.isNotEmpty) profile.name.value = newName;
      if (newDob.isNotEmpty) profile.birthDate.value = newDob;

      Get.snackbar(
        "Berhasil",
        "Profil berhasil diperbarui!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );

      // Kembali ke halaman sebelumnya setelah delay singkat
      await Future.delayed(const Duration(milliseconds: 600));
      Get.back();
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Tidak dapat menyimpan profil: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
