import 'dart:io'; // Import untuk File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    // Data awal dummy (Nanti bisa ambil dari API/Local Storage)
    nameController.text = "Zaidan Rizqullah";
    dateController.text = "24-11-2025";
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
  void saveProfile() {
    // Di sini nanti logika simpan ke Database/API
    Get.snackbar(
      "Berhasil", 
      "Profil berhasil diperbarui!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
    // Kembali ke halaman sebelumnya setelah delay
    Future.delayed(const Duration(seconds: 1), () => Get.back());
  }

  @override
  void onClose() {
    nameController.dispose();
    dateController.dispose();
    super.onClose();
  }
}