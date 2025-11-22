import 'package:flutter/material.dart';
import 'app/modules/login/views/login_view.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/signup/views/signup_view.dart';
import 'app/modules/forgot_password/views/forgot_password_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(), //--- Route ke LoginView
        '/home': (context) => const HomeView(), //--- Route ke HomeView
        '/signup': (context) => const SignUpView(), //--- Route ke Halaman Daftar
        '/forgot-password': (context) => const ForgotPasswordView(), //--- Route ke  Halaman Lupa Password
      },
    );
  }
}