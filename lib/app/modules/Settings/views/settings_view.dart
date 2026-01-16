import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management_app/app/controllers/auth_controller.dart';
import '../../../controllers/profile_controller.dart';
import 'package:task_management_app/app/services/notification_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Future<void> _showReminderDiagnostics(BuildContext context) async {
    final exact = await NotificationService.instance.isExactAlarmsAllowed();
    final ignoring =
        await NotificationService.instance.isIgnoringBatteryOptimizations();
    final pendingSummary =
        await NotificationService.instance.getDeliveryDebugSummary();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reminder Diagnostics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exact alarms allowed: $exact'),
            const SizedBox(height: 6),
            Text('Ignoring battery optimizations: $ignoring'),
            const SizedBox(height: 12),
            const Text('Scheduled state (plugin + fallback):'),
            const SizedBox(height: 6),
            Text(
              pendingSummary,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 12),
            const Text(
              '''Jika scheduled notif tidak muncul (terutama Xiaomi/MIUI), biasanya karena battery restriction.

Yang paling penting:
• App info → Battery saver → pilih “No restrictions”
• App info → Autostart → ON (jika ada)
• Settings → Notifications → pastikan channel “Task Reminders” tidak silent & tampil di lock screen

Catatan: Exact alarms allowed = true saja belum cukup kalau battery optimization masih aktif.''',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await NotificationService.instance
                  .openAndroidSchedulingSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  // Konstanta Rute
  static const String homeRoute = '/home';
  static const String calendarRoute = '/calendar';
  static const String descriptionRoute = '/description';
  static const String settingsRoute = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // Navigator: Kembali ke halaman sebelumnya
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. HEADER PROFIL (BISA DIKLIK) ---
              _buildProfileHeader(),

              const SizedBox(height: 30),

              // --- 2. SECTION CUSTOMIZE ---
              const Text(
                'Customize',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // Opsi Notifications
              _buildOptionTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {
                  // Test notification now: helps verify permission/channel on any device
                  NotificationService.instance.showNow(
                    id: DateTime.now()
                        .millisecondsSinceEpoch
                        .remainder(1 << 31),
                    title: 'Test Notification',
                    body:
                        'Jika ini muncul, izin & channel notifikasi sudah OK.',
                  );
                  Get.snackbar(
                    "Notifications",
                    "Test notification sent",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    duration: const Duration(seconds: 1),
                  );
                },
              ),

              const SizedBox(height: 15),

              _buildOptionTile(
                icon: Icons.notification_important,
                title: 'Debug Heads-Up (must appear now)',
                onTap: () async {
                  await NotificationService.instance.showDebugHeadsUp();
                  Get.snackbar(
                    "Notifications",
                    "Debug heads-up requested",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    duration: const Duration(seconds: 1),
                  );
                },
              ),

              const SizedBox(height: 15),

              _buildOptionTile(
                icon: Icons.settings_suggest,
                title: 'Fix Scheduled Reminders',
                onTap: () async {
                  await NotificationService.instance
                      .openAndroidSchedulingSettings();
                  Get.snackbar(
                    'Info',
                    'Buka menu sistem: aktifkan Exact alarms / No restrictions jika ada.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    duration: const Duration(seconds: 2),
                  );
                },
              ),

              const SizedBox(height: 15),

              _buildOptionTile(
                icon: Icons.alarm_on,
                title: 'Enable Exact Alarms',
                onTap: () async {
                  await NotificationService.instance
                      .requestExactAlarmPermissionIfNeeded();
                  // Show the updated diagnostics after returning
                  await _showReminderDiagnostics(context);
                },
              ),

              const SizedBox(height: 15),

              _buildOptionTile(
                icon: Icons.battery_saver,
                title: 'Disable Battery Optimization',
                onTap: () async {
                  await NotificationService.instance
                      .openAndroidSchedulingSettings();
                  // Refresh diagnostics after user comes back
                  await _showReminderDiagnostics(context);
                },
              ),

              const SizedBox(height: 15),

              _buildOptionTile(
                icon: Icons.notifications_active,
                title: 'Open Notification Settings',
                onTap: () async {
                  await NotificationService.instance
                      .openAndroidNotificationSettings();
                },
              ),

              const SizedBox(height: 15),

              _buildOptionTile(
                icon: Icons.info_outline,
                title: 'Open App Details',
                onTap: () async {
                  await NotificationService.instance.openAndroidAppDetails();
                },
              ),

              const SizedBox(height: 15),

              // Opsi Test Scheduled Notification (+ 1 minute)
              _buildOptionTile(
                icon: Icons.alarm,
                title: 'Test Scheduled (+1 minute)',
                onTap: () async {
                  final now = DateTime.now();
                  final at = now.add(const Duration(minutes: 1));
                  final id =
                      DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);

                  await NotificationService.instance.scheduleOneTimeSmart(
                    id: id,
                    dateTime: at,
                    title: 'Scheduled Test',
                    body: 'Test Secheduled Success.',
                  );

                  Get.snackbar(
                    "Notifications",
                    "Scheduled for ${at.hour.toString().padLeft(2, '0')}:${at.minute.toString().padLeft(2, '0')}",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    duration: const Duration(seconds: 2),
                  );
                },
              ),

              const SizedBox(height: 15),

              _buildOptionTile(
                icon: Icons.bug_report,
                title: 'Reminder Diagnostics',
                onTap: () => _showReminderDiagnostics(context),
              ),

              const SizedBox(height: 15),

              // Opsi Logout
              _buildOptionTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  _handleLogout(context);
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // --- 3. FLOATING ACTION BUTTON (+) ---
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- 4. BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // ==========================================
  //            FUNGSI LOGIKA & WIDGET
  // ==========================================

  // Logika Logout dengan GetX Dialog
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title:
            const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(ctx).pop();

              // Panggil AuthController untuk menghapus sesi Firebase
              final authController = Get.find<AuthController>();
              await authController.signOut();
              // Pindah ke halaman login
              Get.offAllNamed('/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Widget Header Profil (UPDATED: Bisa Diklik)
  Widget _buildProfileHeader() {
    final profile =
        Get.find<ProfileController>(); // Mengambil instance controller

    return GestureDetector(
      onTap: () => Get.toNamed('/edit-profile'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            // --- PERBAIKAN UTAMA: Bungkus bagian foto dengan Obx ---
            Obx(() {
              // Kita gunakan data dari ProfileController, bukan FirebaseAuth langsung
              final String currentPhoto = profile.photoUrl.value;
              ImageProvider? avatarImage;

              if (currentPhoto.isNotEmpty) {
                if (currentPhoto.startsWith('data:image')) {
                  try {
                    final bytes = base64Decode(currentPhoto.split(',').last);
                    avatarImage = MemoryImage(bytes);
                  } catch (e) {
                    avatarImage = null;
                  }
                } else {
                  avatarImage = NetworkImage(currentPhoto);
                }
              }

              return CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: avatarImage,
                child: avatarImage == null
                    ? const Icon(Icons.person, size: 28, color: Colors.black87)
                    : null,
              );
            }),
            const SizedBox(width: 15),

            // Bagian Teks Nama & Tanggal Lahir
            Expanded(
              // Tambahkan Expanded agar tidak overflow jika nama panjang
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => Text(
                        profile.name.value.isNotEmpty
                            ? profile.name.value
                            : 'User',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  Obx(() => Text(
                        profile.birthDate.value.isNotEmpty
                            ? profile.birthDate.value
                            : 'Belum diatur',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      )),
                ],
              ),
            ),

            // Icon Edit
            const Icon(Icons.camera_alt, color: Colors.blue, size: 20),
            const SizedBox(width: 10),
            const Icon(Icons.edit, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  // Widget Item Opsi
  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black87),
            const SizedBox(width: 15),
            // --- PERBAIKAN DI SINI ---
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                // Opsional: jika ingin tetap 1 baris tapi pakai titik-titik di akhir
                // overflow: TextOverflow.ellipsis,
                // maxLines: 1,
              ),
            ),
            // -------------------------
            const SizedBox(width: 10), // Beri jarak sedikit sebelum icon panah
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Widget Tombol Tambah (+)
  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        Get.toNamed('/create-task');
      },
      backgroundColor: Colors.blue,
      elevation: 4.0,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 30, color: Colors.white),
    );
  }

  // Widget Bottom Navigation Bar
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildNavItem(Icons.home, isSelected: false, routeName: homeRoute),
            _buildNavItem(Icons.calendar_month,
                isSelected: false,
                routeName:
                    calendarRoute), // Note: calendar_month or calendar_today depending on your pref
            const SizedBox(width: 40),
            _buildNavItem(Icons.description,
                isSelected: false, routeName: descriptionRoute),
            _buildNavItem(Icons.settings,
                isSelected: true, routeName: settingsRoute), // Aktif
          ],
        ),
      ),
    );
  }

  // Widget Item Navigasi Bottom Bar
  Widget _buildNavItem(IconData icon,
      {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
        size: 24,
      ),
      onPressed: () {
        if (routeName != null && !isSelected) {
          Get.offNamed(routeName);
        }
      },
    );
  }
}
