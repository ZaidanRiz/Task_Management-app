import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/modules/CreateTask/views/create_task_view.dart';
import 'package:task_management_app/app/modules/CreateTask/bindings/create_task_binding.dart';
import 'package:task_management_app/app/modules/Settings/views/settings_view.dart';
import 'app/modules/AllTask/views/all_task_view.dart';
import 'package:task_management_app/app/modules/AllTask/bindings/all_task_binding.dart';
import 'app/modules/login/views/login_view.dart';
import 'package:task_management_app/app/modules/home/bindings/home_binding.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/modules/signup/views/signup_view.dart';
import 'app/modules/forgot_password/views/forgot_password_view.dart';
import 'app/modules/calender/views/calender_view.dart';
import 'package:task_management_app/app/modules/calender/bindings/calendar_binding.dart';
import 'package:task_management_app/app/modules/DetailTask/views/detail_task_view.dart';
import 'package:task_management_app/app/modules/DetailTask/bindings/detail_task_binding.dart';

void main() {
  Get.put(TaskController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),
      initialRoute: '/login',

      // --- PENGATURAN TRANSISI DEFAULT ---
      // Ini akan membuat SEMUA perpindahan halaman memiliki animasi ini
      defaultTransition: Transition.cupertino, // Transisi (geser samping)
      // Pilihan lain: Transition.zoom, Transition.fadeIn, Transition.downToUp

      // --- UBAH 'routes' MENJADI 'getPages' ---
      getPages: [
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(
          name: '/home',
          page: () => const HomeView(),
          binding: HomeBinding(),
          transition:
              Transition.native, // Anda bisa atur transisi KHUSUS di sini
          transitionDuration: const Duration(milliseconds: 1000),
        ),
        GetPage(name: '/signup', page: () => const SignUpView()),
        GetPage(
            name: '/forgot-password', page: () => const ForgotPasswordView()),
        GetPage(
          name: '/calendar',
          page: () => const CalendarView(), // Ganti Class yang lama
          binding: CalendarBinding(), // Tambahkan Binding ini
        ),
        GetPage(
          name: '/description', // Sesuai routeName yang Anda pakai
          page: () => const AllTasksView(),
          binding: AllTaskBinding(), // Inject binding di sini
        ),
        GetPage(name: '/settings', page: () => const SettingsView()),
        GetPage(
          name: '/create-task',
          page: () => const CreateTaskView(),
          binding: CreateTaskBinding(), // <--- Tambahkan Baris Ini
        ),
        GetPage(
          name: '/detail-task',
          page: () => const DetailTaskView(),
          binding: DetailTaskBinding(),
        ),
      ],
    );
  }
}
