import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> currentUser = Rx<User?>(null);
  final isSigningIn = false.obs;

  @override
  @override
  void onInit() {
    super.onInit();
    // 1. Tetap pantau status login agar data currentUser selalu terbaru
    currentUser.bindStream(_auth.authStateChanges());

    debugPrint("DEBUG: User saat init: ${_auth.currentUser?.email}");

    // 2. Inisialisasi nilai awal agar SplashView bisa membaca status saat ini
    currentUser.value = _auth.currentUser;
  }

  // --- LOGIKA PERSISTENSI LOGIN ---
  // Di dalam AuthController.dart
  _setInitialScreen(User? user) {
    if (user == null) {
      // GANTI '/onboarding' menjadi '/login' jika ingin ke halaman login
      Get.offAllNamed('/login');
    } else {
      Get.offAllNamed('/home');
    }
  }

  // --- FUNGSI LOGIN EMAIL ---
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      isSigningIn.value = true;
      UserCredential res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return res.user;
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";

      if (e.code == 'invalid-email') {
        message =
            "Format email salah. Pastikan menggunakan tanda '@' dan domain yang benar.";
      } else if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        message =
            "Email atau Password salah. Silakan periksa kembali akun Anda.";
      }

      Get.snackbar(
        'Login Gagal',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } finally {
      isSigningIn.value = false;
    }
  }

  // --- FUNGSI SIGN UP (Registrasi) ---
  Future<User?> signUp(String name, String email, String password) async {
    try {
      isSigningIn.value = true;

      UserCredential res = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 20));

      if (res.user != null) {
        try {
          await _firestore.collection('users').doc(res.user!.uid).set({
            'uid': res.user!.uid,
            'name': name,
            'email': email.trim().toLowerCase(),
            'photoUrl': '',
            'role': 'user',
            'createdAt': FieldValue.serverTimestamp(),
          }).timeout(const Duration(seconds: 10));

          await res.user!.updateDisplayName(name);
          await res.user!.reload();
        } catch (e) {
          if (res.user != null) await res.user!.delete();
          rethrow;
        }
      }
      return res.user;
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";

      if (e.code == 'invalid-email') {
        message =
            "Format email tidak valid. Pastikan penulisan email benar (contoh: user@mail.com).";
      } else if (e.code == 'email-already-in-use') {
        message = "Email sudah digunakan oleh akun lain.";
      } else if (e.code == 'weak-password') {
        message = "Password terlalu lemah. Gunakan minimal 6 karakter.";
      } else {
        message = e.message ?? "Gagal mendaftar.";
      }

      Get.snackbar(
        'Registrasi Gagal',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } on TimeoutException catch (_) {
      Get.snackbar(
          'Sign Up Gagal', 'Permintaan timeout. Periksa koneksi internet Anda.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } catch (e) {
      Get.snackbar('Sign Up Gagal', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } finally {
      isSigningIn.value = false;
    }
  }

  // --- FUNGSI LOGOUT ---
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // PAKSA nilai currentUser menjadi null agar listener 'ever' langsung bereaksi
      currentUser.value = null;

      // Opsional: Jika Anda ingin memastikan data benar-benar bersih dari memori GetX
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar("Error", "Gagal logout: $e");
    }
  }

  // --- FUNGSI RESET PASSWORD ---
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Email Terkirim",
        "Silakan periksa kotak masuk email Anda untuk mereset password.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on FirebaseAuthException catch (e) {
      String message = "Gagal mengirim email reset.";
      if (e.code == 'user-not-found') {
        message = "Email tidak terdaftar di sistem kami.";
      }
      Get.snackbar(
        "Gagal",
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
