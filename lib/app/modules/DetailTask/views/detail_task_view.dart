import 'package:flutter/material.dart';
import 'package:task_management_app/app/modules/CreateTask/views/create_task_view.dart';
 

class DetailTaskView extends StatefulWidget {
  const DetailTaskView({super.key});

  @override
  State<DetailTaskView> createState() => _DetailTaskViewState();
}

class _DetailTaskViewState extends State<DetailTaskView> {
  // Data Dummy untuk Sub-tasks
  // 'isChecked' digunakan untuk mengatur status centang
  List<Map<String, dynamic>> subTasks = [
    {'title': '#1 Search Refrences', 'isChecked': false},
    {'title': '#2 Search Components', 'isChecked': false},
    {'title': '#3 Create Wireframe', 'isChecked': false},
    {'title': '#4 Define Color Palette & Typography', 'isChecked': false},
    {'title': '#5 Design Key Screens', 'isChecked': false},
    {'title': '#6 Add Interaction / Prototype in Figma', 'isChecked': false},
    {'title': '#7 Review & Feedback', 'isChecked': false},
    {'title': '#8 Revise & Improve Based on Feedback', 'isChecked': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // --- APP BAR ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'RI Task',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black87),
            onPressed: () {
              // Logika Edit Task
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.black87),
            onPressed: () {
              // Logika Hapus Task
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      // --- BODY ---
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Misi
              const Text(
                "Design new ui presentation",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // List Sub-tasks (Menggunakan spread operator ...)
              ...subTasks.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> task = entry.value;
                return _buildSubTaskItem(index, task);
              }),
              
              const SizedBox(height: 80), // Ruang untuk Bottom Nav
            ],
          ),
        ),
      ),

      // --- BOTTOM NAVIGATION & FAB ---
      floatingActionButton: _buildFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Widget Item Sub-Task
  Widget _buildSubTaskItem(int index, Map<String, dynamic> task) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Mengubah status check ketika item ditekan
          subTasks[index]['isChecked'] = !subTasks[index]['isChecked'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.lightBlueAccent), // Border biru sesuai gambar
        ),
        child: Row(
          children: [
            // Checkbox Custom
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: task['isChecked'] ? Colors.blue : Colors.lightBlueAccent,
                  width: 2,
                ),
                color: task['isChecked'] ? Colors.blue : Colors.white,
              ),
              child: task['isChecked']
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 15),
            
            // Teks Task
            Expanded(
              child: Text(
                task['title'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  decoration: task['isChecked'] ? TextDecoration.lineThrough : null, // Coret jika selesai
                  decorationColor: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget FAB
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
            IconButton(
              icon: const Icon(Icons.home, color: Colors.grey), // Home jadi grey karena kita di Detail
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: Colors.grey),
              onPressed: () => Navigator.pushReplacementNamed(context, '/calendar'),
            ),
            const SizedBox(width: 40), 
            IconButton(
              icon: const Icon(Icons.description, color: Colors.blue), // Icon ini aktif (Biru)
              onPressed: () {
                 // Sudah di halaman ini (atau halaman list task)
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey),
              onPressed: () => Navigator.pushReplacementNamed(context, '/settings'),
            ),
          ],
        ),
      ),
    );
  }
}