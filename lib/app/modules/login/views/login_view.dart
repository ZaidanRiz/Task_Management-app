import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final authController = Get.find<AuthController>();

  bool _isObscure = true;

  // LOGIKA LOGIN FIREBASE
  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      // Memanggil fungsi AuthController
      final user = await authController.signInWithEmail(email, password);

      if (user != null) {
        Get.snackbar(
          "Login Berhasil",
          "Selamat datang kembali!",
          icon: const Icon(Icons.check_circle, color: Colors.white),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Delay sebentar untuk transisi mulus
        await Future.delayed(const Duration(milliseconds: 1000));
        Get.offAllNamed('/home'); // Menghapus history navigasi agar tidak bisa back
      }
    } else {
      Get.snackbar(
        "Gagal Masuk",
        "Email dan Password tidak boleh kosong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 25),

                // EMAIL INPUT
                _buildLabel(Icons.email_outlined, "Your email"),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration("Enter your email"),
                ),

                const SizedBox(height: 20),

                // PASSWORD INPUT
                _buildLabel(Icons.lock_outline, "Password"),
                const SizedBox(height: 10),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: _inputDecoration("Enter your password").copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed('/forgot-password'),
                    child: const Text("Forgot Password?", style: TextStyle(color: Colors.blue)),
                  ),
                ),

                const SizedBox(height: 10),

                // TOMBOL LOGIN UTAMA
                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: authController.isSigningIn.value ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: authController.isSigningIn.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                )),

                const SizedBox(height: 12),

                // TOMBOL GOOGLE
                Obx(() {
                  final signing = authController.isSigningIn.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: signing ? null : () async {
                        final res = await authController.signInWithGoogle(forceNewAccount: true);
                        if (res != null) Get.offAllNamed('/home');
                      },
                      icon: signing 
                        ? const SizedBox() 
                        : Image.asset('assets/images/Google.png', width: 22, errorBuilder: (c, e, s) => const Icon(Icons.g_mobiledata, color: Colors.blue)),
                      label: Text(signing ? 'Memproses...' : 'Masuk dengan Google', style: const TextStyle(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 30),

                // SIGN UP REDIRECT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Get.toNamed('/signup'),
                      child: const Text("Sign up", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // HELPER STYLING
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
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
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