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

  // Variable untuk mengatur status sembunyi/lihat password
  bool _isObscure = true;

  // LOGIKA LOGIN DENGAN GETX & DELAY
  void _handleLogin() async {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      // 1. Tampilkan Notifikasi SUKSES
      Get.snackbar(
        "Login Berhasil",
        "Selamat datang kembali!",
        icon: const Icon(Icons.check_circle, color: Colors.white),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );

      // 2. Beri jeda waktu agar notif terbaca dulu
      await Future.delayed(const Duration(milliseconds: 1500));

      // 3. Pindah ke Home & Hapus History (agar user tidak bisa back ke login)
      Get.offNamed('/home');
    } else {
      // Notifikasi ERROR
      Get.snackbar(
        "Gagal Masuk",
        "Email dan Password tidak boleh kosong",
        icon: const Icon(Icons.error, color: Colors.white),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER CENTERED
                const Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 2. TEXT LOGIN BIRU
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 25),

                // 3. EMAIL SECTION
                Row(
                  children: const [
                    Icon(Icons.email_outlined, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Your email",
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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

                const SizedBox(height: 20),

                // 4. PASSWORD SECTION
                Row(
                  children: const [
                    Icon(Icons.lock_outline, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Password",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),

                // Forgot Password
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed('/forgot-password');
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 5. BUTTON LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                // --- LOGIN DENGAN GOOGLE (tepat di bawah tombol Login) ---
                Obx(() {
                  final signing = Get.find<AuthController>().isSigningIn.value;
                  return SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: signing
                          ? null
                          : () async {
                              final auth = Get.find<AuthController>();
                              final res = await auth.signInWithGoogle(
                                  forceNewAccount: true);
                              if (res != null) Get.offNamed('/home');
                            },
                      icon: signing
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Image.asset(
                              'assets/images/Google.png',
                              width: 22,
                              height: 22,
                              errorBuilder: (context, error, stack) =>
                                  const Icon(Icons.g_mobiledata,
                                      color: Colors.blue),
                            ),
                      label: Text(
                        signing ? 'Memproses...' : 'Masuk dengan Google',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/signup');
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
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
}
