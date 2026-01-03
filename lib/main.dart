import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:task_management_app/app/controllers/task_controller.dart';
import 'package:task_management_app/app/controllers/auth_controller.dart';
import 'package:task_management_app/app/controllers/profile_controller.dart';
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
import 'package:task_management_app/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:task_management_app/app/modules/onboarding/views/onboarding_view.dart';
import 'package:task_management_app/app/modules/AiAssistant/bindings/ai_assistant_binding.dart';
import 'package:task_management_app/app/modules/AiAssistant/views/ai_assistant_view.dart';
import 'package:task_management_app/app/modules/EditProfile/bindings/edit_profile_binding.dart';
import 'package:task_management_app/app/modules/EditProfile/views/edit_profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inisialisasi controller SETELAH Firebase siap
  Get.put(AuthController());
  Get.put(TaskController());
  Get.put(ProfileController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Ensure GetX snackbar controller is initialized to avoid late init errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        Get.snackbar('', '',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.transparent,
            duration: const Duration(milliseconds: 1));
      } catch (_) {}
    });
  }

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
      initialRoute: '/onboarding',

      // --- PENGATURAN TRANSISI DEFAULT ---
      // Ini akan membuat SEMUA perpindahan halaman memiliki animasi ini
      defaultTransition: Transition.cupertino, // Transisi (geser samping)
      // Pilihan lain: Transition.zoom, Transition.fadeIn, Transition.downToUp

      // --- UBAH 'routes' MENJADI 'getPages' ---
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
        ),
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
          page: () => AllTasksView(),
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
        GetPage(
          name: '/onboarding',
          page: () => const OnboardingView(),
          binding: OnboardingBinding(),
        ),
        GetPage(
          name: '/ai-assistant',
          page: () => const AiAssistantView(),
          binding: AiAssistantBinding(),
        ),
        GetPage(
          name: '/edit-profile',
          page: () => const EditProfileView(),
          binding: EditProfileBinding(),
        ),
      ],
    );
  }
}
