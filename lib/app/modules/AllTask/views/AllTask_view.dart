import 'package:flutter/material.dart';
import 'package:task_management_app/app/modules/calender/views/calender_view.dart';

// Asumsi: TaskCard sudah didefinisikan atau diimpor
// Jika TaskCard Anda berada di ../widgets/task_card.dart, pastikan impornya benar.
// import '../widgets/task_card.dart'; 

class AllTasksView extends StatelessWidget {
  const AllTasksView({super.key});

  // --- Data Tugas (Sesuai Gambar) ---
  final List<Map<String, dynamic>> todayTasks = const [
    {
      'title': 'Design new ui presentation',
      'project': 'RI Task',
      'progress': 10,
      'total': 10,
      'date': '7 Nov 2025',
      'dateColor': Colors.red,
      'progressColor': Colors.green, // 10/10
    },
    {
      'title': 'Add more ui/ux to mockups',
      'project': 'PKPL Task',
      'progress': 7,
      'total': 10,
      'date': '19 Nov 2025',
      'dateColor': Color(0xFFF7941D), // Oranye
      'progressColor': Colors.orange, // 7/10
    },
  ];

  final List<Map<String, dynamic>> upcomingTasks = const [
    {
      'title': 'Search Idea of Problems',
      'project': 'RI Task',
      'progress': 3,
      'total': 10,
      'date': '1 Des 2025',
      'dateColor': Color(0xFF6C63FF), // Ungu/Biru Muda
      'progressColor': Colors.blue, // 3/10
    },
  ];

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------
    // Menggunakan Scaffold dengan pengaturan Bottom Bar yang sama
    // ----------------------------------------------------
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
        ),
        title: const Text(
          'All Tasks',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // --- TODAY'S TASK ---
              _buildTaskHeader("Today's task"),
              ...todayTasks.map((task) => _buildTaskCard(task)).toList(),

              const SizedBox(height: 20),

              // --- UPCOMING TASK ---
              _buildTaskHeader("Upcoming task"),
              ...upcomingTasks.map((task) => _buildTaskCard(task)).toList(),
              
              const SizedBox(height: 100), // Ruang agar tidak tertutup Bottom Bar
            ],
          ),
        ),
      ),

      // ----------------------------------------------------
      // Bottom Bar (Diambil dari desain sebelumnya)
      // ----------------------------------------------------
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- WIDGET PEMBANTU ---

  // Header Tugas
  Widget _buildTaskHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // TaskCard Helper (Menggunakan widget TaskCard yang sudah ada)
  Widget _buildTaskCard(Map<String, dynamic> task) {
    return TaskCard(
      title: task['title']!,
      project: task['project']!,
      progress: task['progress']!,
      total: task['total']!,
      date: task['date']!,
      dateColor: task['dateColor']!,
      progressColor: task['progressColor']!,
    );
  }

  // Floating Action Button
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
    const String homeRoute = '/home';
    const String calendarRoute = '/calendar';
    const String descriptionRoute = '/description'; // Rute untuk halaman ini
    const String settingsRoute = '/settings';
    
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Home
            _buildNavItem(context, Icons.home, isSelected: false, routeName: homeRoute),
            // Kalender
            _buildNavItem(context, Icons.calendar_today, isSelected: false, routeName: calendarRoute), 
            const SizedBox(width: 40), 
            // Deskripsi (All Tasks) - Terpilih di halaman ini
            _buildNavItem(context, Icons.description, isSelected: true, routeName: descriptionRoute),
            // Pengaturan
            _buildNavItem(context, Icons.settings, isSelected: false, routeName: settingsRoute),
          ],
        ),
      ),
    );
  }

  // Fungsi Helper untuk Item Navigasi (Harus di luar kelas Stateless/Stateful)
  Widget _buildNavItem(BuildContext context, IconData icon, {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
        size: 24,
      ),
      onPressed: () {
        if (routeName != null && !isSelected) {
          // Navigasi menggantikan halaman saat ini
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}