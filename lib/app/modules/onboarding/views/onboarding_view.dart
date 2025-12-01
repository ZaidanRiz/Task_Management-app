import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(), 

              // --- 1. ILUSTRASI GAMBAR ---
              // Pastikan nama file sesuai dengan yang Anda simpan di assets
              Image.asset(
                'assets/images/Home.png', 
                height: 350, 
                fit: BoxFit.contain,
                // Jika gambar belum ada, kode ini akan error sementara. 
                // Bisa diganti Icon sementara: Icon(Icons.image, size: 200, color: Colors.blue.shade100),
              ),

              const SizedBox(height: 40),

              // --- 2. JUDUL UTAMA (RichText untuk warna beda) ---
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2, // Jarak antar baris
                    fontFamily: 'Poppins', // Opsional jika pakai font custom
                  ),
                  children: [
                    TextSpan(text: 'Simplify, Organize, and Conquer '),
                    TextSpan(
                      text: 'Your Day',
                      style: TextStyle(color: Colors.blue), // Warna Biru
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // --- 3. SUB JUDUL ---
              const Text(
                'Take control of your tasks and achieve your goals.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),

              const Spacer(), // Mendorong tombol ke bawah

              // --- 4. TOMBOL LETS START ---
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => controller.goToLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Pill Shape
                    ),
                  ),
                  child: const Text(
                    'Lets Start',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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