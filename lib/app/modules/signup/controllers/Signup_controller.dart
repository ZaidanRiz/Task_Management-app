import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;

  Future<void> handleSignUp(String name, String email, String password) async {
    // Validasi tambahan: Cek format email sederhana
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Format email tidak valid",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (password.length < 6) {
      Get.snackbar("Error", "Password minimal 6 karakter",
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;

      // 1. Firebase Auth
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // 2. Gunakan Map atau Model untuk simpan ke Firestore
      // Modifikasi: Nama koleksi sebaiknya lowercase 'users' (konvensi umum)
      await _firestore.collection('User').doc(res.user!.uid).set({
        'uid': res.user!.uid,
        'username': name,
        'email': email.trim().toLowerCase(),
        'photoUrl': '', // Tambahkan field kosong untuk foto profil nanti
        'role': 'user', // Tambahkan role jika diperlukan
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar("Berhasil", "Akun berhasil dibuat!",
          backgroundColor: Colors.green, colorText: Colors.white);

      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login');

    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";
      if (e.code == 'email-already-in-use') {
        message = "Email ini sudah terdaftar.";
      } else if (e.code == 'weak-password') {
        message = "Password terlalu lemah.";
      }
      Get.snackbar("Gagal", message,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan sistem",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}