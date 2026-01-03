import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  // Controller untuk menangkap input email
  final _emailController = TextEditingController();

  // LOGIKA RESET PASSWORD
  void _handleResetPassword() async {
    if (_emailController.text.isNotEmpty) {
      // 1. Tampilkan Notifikasi SUKSES
      Get.snackbar(
        "Email Terkirim",
        "Link reset password telah dikirim ke email Anda.",
        icon: const Icon(Icons.mark_email_read, color: Colors.white),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        duration: const Duration(seconds: 3),
      );

      // 2. Delay sebentar
      await Future.delayed(const Duration(milliseconds: 2000));

      // 3. Kembali ke halaman Login otomatis
      Get.back(closeOverlays: false);
    } else {
      // Notifikasi ERROR jika email kosong
      Get.snackbar(
        "Gagal",
        "Harap masukkan alamat email Anda.",
        icon: const Icon(Icons.warning, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol Back Custom (Panah kecil)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          // Menggunakan GetX untuk kembali
          onPressed: () => Get.back(closeOverlays: false),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // --- JUDUL HALAMAN ---
              const Text(
                "Forgot your password?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // --- DESKRIPSI ---
              const Text(
                "A code will be sent to your email to help reset password",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),

              const SizedBox(height: 40),

              // --- INPUT EMAIL ---
              Row(
                children: const [
                  Icon(Icons.email_outlined, size: 18, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    "Email Address",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- TOMBOL RESET ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleResetPassword, // Panggil logika di atas
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const Spacer(), // Mendorong widget di bawahnya ke paling bawah layar

              // --- LINK BACK TO LOGIN ---
              Center(
                child: TextButton(
                  // Menggunakan GetX untuk kembali
                  onPressed: () => Get.back(closeOverlays: false),
                  child: const Text(
                    "Back to login",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
