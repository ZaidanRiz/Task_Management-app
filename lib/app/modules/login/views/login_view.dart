import 'package:flutter/material.dart';

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

  void _handleLogin() {
    if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center( // Center agar konten berada di tengah secara vertikal jika layar tinggi
          child: SingleChildScrollView( // Agar tidak error jika keyboard muncul
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Default rata kiri untuk elemen anak
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
                // Label di atas TextField
                Row(
                  children: const [
                    Icon(Icons.email_outlined, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Your email",
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                
                // Input Field Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email", // Placeholder di dalam
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Lebih bulat
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
                // Label di atas TextField
                Row(
                  children: const [
                    Icon(Icons.lock_outline, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Password",
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Input Field Password
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure, // Menggunakan variable state
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20), // Lebih bulat
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    // Tombol Mata (Hide/Show)
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure; // Membalikkan nilai true/false
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
                    Navigator.pushNamed(context, '/forgot-password');
                    },
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),

                // 5. BUTTON LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 55, // Sedikit lebih tinggi biar gagah
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 0, // Flat design
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Sangat bulat (Pill shape)
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 18, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // Sign Up Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have a account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
          },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
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