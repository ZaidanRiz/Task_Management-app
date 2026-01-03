import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../controllers/profile_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
                  Get.snackbar(
                    "Notifications",
                    "Notification settings clicked",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    duration: const Duration(seconds: 1),
                  );
                },
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
            onPressed: () {
              Navigator.of(ctx).pop();
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
    final profile = Get.find<ProfileController>();
    return GestureDetector(
      // 1. Bungkus dengan GestureDetector
      onTap: () {
        // 2. Navigasi ke halaman Edit Profile
        Get.toNamed('/edit-profile');
      },
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
            // Profile photo (if available) otherwise default icon
            Builder(builder: (_) {
              final user = FirebaseAuth.instance.currentUser;
              ImageProvider? avatarImage;
              if (user?.photoURL != null && user!.photoURL!.isNotEmpty) {
                final val = user.photoURL!;
                if (val.startsWith('data:image')) {
                  try {
                    final parts = val.split(',');
                    final bytes = base64Decode(parts.last);
                    avatarImage = MemoryImage(bytes);
                  } catch (e) {
                    avatarImage = NetworkImage(user.photoURL!);
                  }
                } else {
                  avatarImage = NetworkImage(user.photoURL!);
                }
              }

              return Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: avatarImage,
                    child: avatarImage == null
                        ? const Icon(Icons.person,
                            size: 28, color: Colors.black87)
                        : null,
                  ),
                  const SizedBox(width: 15),
                ],
              );
            }),
            Column(
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
                          : '24-11-2025',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    )),
              ],
            ),
            const Spacer(),
            // 3. Tombol Kamera & Icon Edit sebagai penanda visual
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.blue),
                  onPressed: () {
                    // langsung ke Edit Profile untuk mengubah foto
                    Get.toNamed('/edit-profile');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () {
                    Get.toNamed('/edit-profile');
                  },
                ),
              ],
            ),
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
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
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
