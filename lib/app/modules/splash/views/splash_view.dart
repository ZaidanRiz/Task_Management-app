import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:get/get.dart';
import 'package:task_management_app/app/controllers/auth_controller.dart';
import 'package:task_management_app/app/modules/home/views/home_view.dart';
import 'package:task_management_app/app/modules/login/views/login_view.dart';
import 'package:task_management_app/app/modules/onboarding/views/onboarding_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Memastikan AuthController tersedia
    final authController = Get.find<AuthController>();

    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon/logo.png', // Pastikan path benar
              width: 120,
            )
          ],
        ),
      ),
      // MENGGUNAKAN LOGIKA SEDERHANA TANPA OBX DI SINI
      // Kita ambil status terakhir dari Firebase Auth langsung
      nextScreen: authController.currentUser.value != null 
          ? const HomeView() 
          : const LoginView(),
      splashIconSize: 200,
      duration: 3000,
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: const Color.fromARGB(255, 251, 252, 252),
    );
  }
}
