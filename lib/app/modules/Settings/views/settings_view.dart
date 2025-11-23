import 'package:flutter/material.dart';

// --- TASK CARD (Disediakan di sini untuk kelengkapan, meskipun tidak digunakan di halaman ini) ---
// Jika TaskCard berada di file terpisah, hapus kode ini dan ganti dengan: import '../widgets/task_card.dart';
class TaskCard extends StatelessWidget {
  final String title;
  final String project;
  final int progress;
  final int total;
  final String date;
  final Color dateColor;
  final Color progressColor;

  const TaskCard({
    super.key,
    required this.title,
    required this.project,
    required this.progress,
    required this.total,
    required this.date,
    required this.dateColor,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    // Isi TaskCard dihilangkan untuk fokus pada SettingsView
    return const SizedBox.shrink(); 
  }
}

// --- WIDGET HALAMAN PENGATURAN UTAMA (SettingsView) ---

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  // Asumsi rute untuk navigasi Bottom Bar
  static const String homeRoute = '/home'; // Menggunakan /home sesuai definisi Anda
  static const String calendarRoute = '/calendar';
  static const String descriptionRoute = '/description'; // Rute AllTasksView
  static const String settingsRoute = '/settings'; // Rute halaman ini

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
              // 1. HEADER PROFIL
              _buildProfileHeader(),
              const SizedBox(height: 30),

              // 2. JUDUL CUSTOMIZE
              const Text(
                'Customize',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 15),

              // 3. OPSI NOTIFICATIONS
              _buildOptionTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () {},
              ),
              const SizedBox(height: 15),

              // 4. OPSI LOGOUT
              _buildOptionTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {},
              ),
              
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // 5. BOTTOM NAVIGATION BAR
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- WIDGET HELPER ---

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
                'Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '6, October 2023',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.add, size: 30, color: Colors.white),
      backgroundColor: Colors.blue,
      elevation: 4.0,
      shape: const CircleBorder(),
    );
  }

  // Bottom Navigation Bar
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
            // Home: Navigasi ke HomeView
            _buildNavItem(context, Icons.home, isSelected: false, routeName: homeRoute),
            
            // Kalender: Navigasi ke CalendarTasksScreen
            _buildNavItem(context, Icons.calendar_today, isSelected: false, routeName: calendarRoute), 
            
            const SizedBox(width: 40), 
            
            // Deskripsi: Navigasi ke AllTasksView
            _buildNavItem(context, Icons.description, isSelected: false, routeName: descriptionRoute),
            
            // Pengaturan: Halaman ini terpilih
            _buildNavItem(context, Icons.settings, isSelected: true, routeName: settingsRoute), 
          ],
        ),
      ),
    );
  }
  
  // FUNGSI HELPER UNTUK ITEM NAVIGASI DENGAN LOGIKA ROUTING
  Widget _buildNavItem(BuildContext context, IconData icon, {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
        size: 24,
      ),
      onPressed: () {
        if (routeName != null && !isSelected) {
          // Menggunakan pushReplacementNamed untuk navigasi antar halaman utama
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}