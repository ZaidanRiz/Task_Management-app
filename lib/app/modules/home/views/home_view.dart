import 'package:flutter/material.dart';
// Import widget pecahan dari folder sebelah
import '../widgets/task_card.dart'; 

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search for Tasks",
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              // Categories
              const Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard(Icons.checklist, "To Do List", Colors.blue),
                  _buildCategoryCard(Icons.games, "Task For Kids", Colors.orange),
                  _buildCategoryCard(Icons.lightbulb, "AI Assistant", Colors.yellow),
                ],
              ),

              const SizedBox(height: 30),

              // Today's Task (Menggunakan Widget TaskCard yang dipisah)
              const Text("Today's task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const TaskCard(
                title: "Add more ui/ux to mockups",
                subtitle: "PKPL Task",
                date: "19 Nov 2025",
                progress: 0.7,
                progressText: "7/10",
              ),

              const SizedBox(height: 20),

              // Upcoming Task
              const Text("Upcoming task", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              const TaskCard(
                title: "Search Idea of Problems",
                subtitle: "RI Task",
                date: "1 Des 2025",
                progress: 0.3,
                progressText: "3/10",
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home, color: Colors.blue)),
              IconButton(
    onPressed: () {
      // Navigasi ke rute yang didefinisikan di main.dart
      Navigator.pushNamed(context, '/calendar'); 
    },
    // Icon dipindahkan ke sini
    icon: const Icon(Icons.calendar_month, color: Colors.grey)
  ),
              const SizedBox(width: 40),
              IconButton(onPressed: () {}, icon: const Icon(Icons.description, color: Colors.grey)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk Kategori (masih cukup kecil untuk ditaruh di sini)
  Widget _buildCategoryCard(IconData icon, String title, Color color) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 1),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

