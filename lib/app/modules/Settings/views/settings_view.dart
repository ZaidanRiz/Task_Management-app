import 'package:flutter/material.dart';

// 1. IMPORT HALAMAN YANG DIBUTUHKAN
// Sesuaikan path ini dengan struktur folder project Anda
import '../../CreateTask/views/create_task_view.dart'; 
import '../../login/views/login_view.dart'; 

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  // Konstanta Rute untuk Bottom Navigation Bar
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
          onPressed: () => Navigator.pop(context),
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
              // --- 1. HEADER PROFIL ---
              _buildProfileHeader(),
              
              const SizedBox(height: 30),

              // --- 2. SECTION CUSTOMIZE ---
              const Text(
                'Customize',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // Opsi Notifications
              _buildOptionTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {
                  // Tambahkan logika notifikasi di sini jika ada
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Notification settings clicked")),
                  );
                },
              ),
              
              const SizedBox(height: 15),

              // Opsi Logout (DENGAN LOGIKA LOGOUT)
              _buildOptionTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  _handleLogout(context);
                },
              ),
              
              const SizedBox(height: 100), // Spasi bawah agar tidak tertutup FAB/BottomBar
            ],
          ),
        ),
      ),

      // --- 3. FLOATING ACTION BUTTON (+) ---
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      // --- 4. BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // ==========================================
  //           FUNGSI LOGIKA & WIDGET
  // ==========================================

  // Logika Logout
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(); // Tutup Dialog
                
                // NAVIGASI KE LOGIN DAN HAPUS HISTORY
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()), 
                  (Route<dynamic> route) => false, // false = hapus semua rute sebelumnya
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Widget Header Profil
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: const Row(
        children: [
          Icon(Icons.person_pin, size: 40, color: Colors.black87),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name', // Bisa diganti variabel nama user
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '6, October 2023', // Bisa diganti tanggal hari ini
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Item Opsi (Notification / Logout)
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
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
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
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Navigasi ke CreateTaskView
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateTaskView()),
        );
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
            _buildNavItem(context, Icons.home, isSelected: false, routeName: homeRoute),
            _buildNavItem(context, Icons.calendar_today, isSelected: false, routeName: calendarRoute),
            const SizedBox(width: 40), // Spasi untuk FAB
            _buildNavItem(context, Icons.description, isSelected: false, routeName: descriptionRoute),
            _buildNavItem(context, Icons.settings, isSelected: true, routeName: settingsRoute), // Aktif
          ],
        ),
      ),
    );
  }
  
  // Widget Item Navigasi Bottom Bar
  Widget _buildNavItem(BuildContext context, IconData icon, {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
        size: 24,
      ),
      onPressed: () {
        if (routeName != null && !isSelected) {
          // Pindah halaman menggunakan Named Route
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}