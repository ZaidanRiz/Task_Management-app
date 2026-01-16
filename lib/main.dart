import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:task_management_app/app/modules/home/controllers/home_controller.dart';
import 'package:task_management_app/app/modules/splash/views/splash_view.dart';
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
import 'package:task_management_app/app/services/notification_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inisialisasi Analytics
  FirebaseAnalytics.instance;

  // Initialize local notifications with user's timezone
  await NotificationService.instance.init();
  // Inisialisasi controller SETELAH Firebase siap
  Get.put(AuthController(), permanent: true);
  Get.put(TaskController());
  Get.put(ProfileController());
  Get.lazyPut(() => HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Ubah ke StatelessWidget jika tidak ada logika khusus
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        useMaterial3: true,
      ),

      // --- PERUBAHAN KRUSIAL ---
      // Jangan gunakan initialRoute. Biarkan AuthController yang menentukan.
      home: const SplashView(),

      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 400), // Durasi ideal

      // --- UBAH 'routes' MENJADI 'getPages' ---
      getPages: [
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          transition: Transition.fadeIn, // Transisi halus saat masuk login
        ),
        GetPage(
          name: '/home',
          page: () => const HomeView(),
          binding: HomeBinding(),
          // Menggunakan native agar smooth mengikuti OS
          transition: Transition.native,
          transitionDuration: const Duration(milliseconds: 500),
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
          binding: CreateTaskBinding(),
          curve: Curves.easeInOut,
        ),
        GetPage(
          name: '/detail-task',
          page: () => const DetailTaskView(),
          binding: DetailTaskBinding(),
          transition:
              Transition.cupertino, // Geser ala iOS sangat smooth untuk detail
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
