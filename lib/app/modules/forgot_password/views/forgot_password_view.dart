import 'package:flutter/material.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // Kita pakai TextEditingController meski stateles, biasanya disimpan di state/controller terpisah
    final emailController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // Tombol Back Custom (Panah kecil)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
                "Forgot your password?", // Sesuai teks di PDF [cite: 33, 76]
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              // --- DESKRIPSI ---
              const Text(
                "A code will be sent to your email to help reset password", // Sesuai teks di PDF [cite: 34, 77]
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              
              const SizedBox(height: 40),

              // --- INPUT EMAIL ---
              Row(
                children: const [
                  Icon(Icons.email_outlined, size: 18, color: Colors.black54),
                  SizedBox(width: 8),
                  Text(
                    "Email Address", // Sesuai teks di PDF [cite: 35, 78]
                    style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
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

              const SizedBox(height: 30),

              // --- TOMBOL RESET ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // Tampilkan pesan sukses dummy
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reset code sent to email!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Pill shape
                    ),
                  ),
                  child: const Text(
                    "Reset Password", // Sesuai teks di PDF [cite: 37, 80]
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const Spacer(), // Mendorong widget di bawahnya ke paling bawah layar

              // --- LINK BACK TO LOGIN ---
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Back to login", 
                    style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),
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