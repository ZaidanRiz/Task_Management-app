import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/auth_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _emailController = TextEditingController();
  final authController = Get.find<AuthController>(); // Ambil controller utama

  void _handleResetPassword() async {
    String email = _emailController.text.trim();

    if (email.isNotEmpty) {
      // Panggil fungsi reset dari AuthController agar notifikasi tidak double
      await authController.resetPassword(email);
      
      // Jika berhasil, beri jeda lalu kembali ke login
      await Future.delayed(const Duration(milliseconds: 2000));
      Get.back();
    } else {
      Get.snackbar(
        "Gagal",
        "Harap masukkan alamat email Anda.",
        icon: const Icon(Icons.warning, color: Colors.white),
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      // MENGGUNAKAN SingleChildScrollView UNTUK MENGHINDARI OVERFLOW KEYBOARD
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Forgot your password?",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "A code will be sent to your email to help reset password",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 40),
              
              // INPUT EMAIL
              _buildLabel(Icons.email_outlined, "Email Address"),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Enter your email"),
              ),
              const SizedBox(height: 30),

              // TOMBOL RESET
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _handleResetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              
              const SizedBox(height: 50), // Pengganti Spacer agar tidak overflow

              Center(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Back to login",
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper UI agar seragam dengan halaman Login
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  Widget _buildLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
      ],
    );
  }
}