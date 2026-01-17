import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  var isLoading = false.obs;

  Future<void> sendResetPasswordEmail() async {
    String email = emailController.text.trim().toLowerCase();

    if (email.isEmpty) {
      Get.snackbar("Peringatan", "Silakan masukkan alamat email Anda.",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // 1. Validasi: Cek apakah email terdaftar di koleksi 'users' Firestore
      var userQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        Get.snackbar("Gagal", "Email tidak ditemukan di database kami.",
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        // 2. Kirim email reset password resmi dari Firebase Auth
        await _auth.sendPasswordResetEmail(email: email);

        Get.snackbar(
          "Email Terkirim",
          "Link reset password telah dikirim ke email Anda.",
          icon: const Icon(Icons.mark_email_read, color: Colors.white),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await Future.delayed(const Duration(seconds: 3));
        Get.back(); // Kembali ke halaman login
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Terjadi kesalahan",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}