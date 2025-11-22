import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  // Controller untuk menangkap input user
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // State untuk sembunyikan password
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea memastikan konten tidak tertutup status bar HP
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BAGIAN HEADER ---
                const Center(
                  child: Text(
                    "Create Account", // Sesuai teks di PDF [cite: 14, 23]
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Sign up to get started",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                
                const SizedBox(height: 30),

                // --- INPUT USERNAME ---
                // Label Username
                Row(
                  children: const [
                    Icon(Icons.person_outline, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Your Username", // Sesuai teks di PDF [cite: 15, 24]
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // TextField Username
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Create a username",
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
                  ),
                ),

                const SizedBox(height: 20),

                // --- INPUT EMAIL ---
                // Label Email
                Row(
                  children: const [
                    Icon(Icons.email_outlined, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Your email", // Sesuai teks di PDF [cite: 16, 26]
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // TextField Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
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
                  ),
                ),

                const SizedBox(height: 20),

                // --- INPUT PASSWORD ---
                // Label Password
                Row(
                  children: const [
                    Icon(Icons.lock_outline, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      "Password", // Sesuai teks di PDF [cite: 18, 28]
                      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // TextField Password
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure, // Bisa di-hide/show
                  decoration: InputDecoration(
                    hintText: "Create a password",
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
                    // Ikon mata untuk lihat password
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // --- TOMBOL SIGN UP ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Logika Sign Up Dummy
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30), // Pill shape
                      ),
                    ),
                    child: const Text(
                      "Sign Up", // Sesuai teks di PDF [cite: 19, 30]
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // --- LINK KE LOGIN ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a user? "), // Sesuai teks di PDF [cite: 20, 31]
                    GestureDetector(
                      onTap: () {
                        // Kembali ke halaman Login (pop)
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Sign in",
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