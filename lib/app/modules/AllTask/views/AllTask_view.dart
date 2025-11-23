import 'package:flutter/material.dart';
import 'package:task_management_app/app/modules/CreateTask/views/create_task_view.dart';
// 1. Import halaman CreateTaskView

// Asumsi: Widget TaskCard ada di file terpisah. 
// Jika belum, Anda bisa menyalin class TaskCard dari file sebelumnya ke bagian bawah file ini.
// import '../widgets/task_card.dart'; 

class AllTasksView extends StatelessWidget {
  const AllTasksView({super.key});

  // --- Data Tugas ---
  final List<Map<String, dynamic>> todayTasks = const [
    {
      'title': 'Design new ui presentation',
      'project': 'RI Task',
      'progress': 10,
      'total': 10,
      'date': '7 Nov 2025',
      'dateColor': Colors.red,
      'progressColor': Colors.green,
    },
    {
      'title': 'Add more ui/ux to mockups',
      'project': 'PKPL Task',
      'progress': 7,
      'total': 10,
      'date': '19 Nov 2025',
      'dateColor': Color(0xFFF7941D),
      'progressColor': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> upcomingTasks = const [
    {
      'title': 'Search Idea of Problems',
      'project': 'RI Task',
      'progress': 3,
      'total': 10,
      'date': '1 Des 2025',
      'dateColor': Color(0xFF6C63FF),
      'progressColor': Colors.blue,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
              
              const SizedBox(height: 100), 
            ],
          ),
        ),
      ),

      // 2. Update pemanggilan _buildFAB dengan menyertakan context
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // --- WIDGET PEMBANTU ---

  Widget _buildTaskHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    // Pastikan Widget TaskCard sudah tersedia (diimport atau didefinisikan di file ini)
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

  // 3. Update Logic FAB: Menambahkan parameter context dan Navigator.push
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
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

  Widget _buildBottomNavBar(BuildContext context) {
    const String homeRoute = '/home';
    const String calendarRoute = '/calendar';
    const String descriptionRoute = '/description'; 
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
            _buildNavItem(context, Icons.home, isSelected: false, routeName: homeRoute),
            _buildNavItem(context, Icons.calendar_today, isSelected: false, routeName: calendarRoute), 
            const SizedBox(width: 40), 
            _buildNavItem(context, Icons.description, isSelected: true, routeName: descriptionRoute),
            _buildNavItem(context, Icons.settings, isSelected: false, routeName: settingsRoute),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, {bool isSelected = false, String? routeName}) {
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.black54,
        size: 24,
      ),
      onPressed: () {
        if (routeName != null && !isSelected) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}

// --- DUMMY TASK CARD (Hapus jika sudah import dari file lain) ---
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
    double progressPercentage = progress / total;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: dateColor.withOpacity(0.4), width: 1),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.15), spreadRadius: 2, blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Icon(Icons.more_horiz, color: Colors.grey),
          ]),
          const SizedBox(height: 5),
          Text(project, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          const SizedBox(height: 15),
          Row(children: [
            const Icon(Icons.list_alt, size: 14, color: Colors.grey),
            const SizedBox(width: 5),
            const Text('Progress', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(width: 10),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progressPercentage,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text('$progress/$total', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: dateColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(date, style: TextStyle(color: dateColor, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}