import 'package:flutter/material.dart';

class CreateTaskView extends StatefulWidget {
  const CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  // 1. Data Label Hari
  final List<String> days = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];
  
  // 2. Status Pilihan (Default: semua false/belum dipilih)
  List<bool> selectedDays = [false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(hint: 'Masukkan Nama Misi'),
            const SizedBox(height: 20),
            const Text('Steps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _buildTextField(hint: 'Masukkan Sub Task'),
            const SizedBox(height: 10),
            _buildTextField(hint: 'Masukkan Sub Task'),
            const SizedBox(height: 10),
            _buildTextField(hint: 'Masukkan Sub Task'),
            const SizedBox(height: 20),
            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            _buildTextField(hint: 'Masukkan Tanggal Deadline (DD/MM/YY)', suffixIcon: Icons.calendar_today, isRedIcon: true),
            const SizedBox(height: 20),
            const Text('Reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            // 3. Panggil Widget Reminder Box yang sudah diupdate
            _buildReminderBox(),
            
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade100,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Tampilkan Notifikasi Berhasil
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Berhasil menambahkan task!'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hint, IconData? suffixIcon, bool isRedIcon = false}) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.lightBlueAccent)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: isRedIcon ? Colors.redAccent : Colors.grey) : null,
      ),
    );
  }

  // 4. Widget Reminder Box yang sudah Interaktif
  Widget _buildReminderBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.lightBlueAccent), 
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Berikan Notifikasi Setiap:', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(height: 10),
              
              // Generate tombol hari berdasarkan list
              Row(
                children: List.generate(days.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      // Logic: Ubah status terpilih true <-> false
                      setState(() {
                        selectedDays[index] = !selectedDays[index];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 30, // Lebar area sentuh
                      height: 30, // Tinggi area sentuh
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // Jika dipilih warna Biru, jika tidak transparan
                        color: selectedDays[index] ? Colors.blue : Colors.transparent,
                        shape: BoxShape.circle, // Bentuk bulat
                      ),
                      child: Text(
                        days[index],
                        style: TextStyle(
                          // Jika dipilih text Putih, jika tidak Abu-abu
                          color: selectedDays[index] ? Colors.white : Colors.grey,
                          fontWeight: selectedDays[index] ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          const Icon(Icons.notifications_active_outlined, color: Colors.orange, size: 30),
        ],
      ),
    );
  }
}