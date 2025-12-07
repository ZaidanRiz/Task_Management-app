import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_task_controller.dart';

class CreateTaskView extends GetView<CreateTaskController> {
  const CreateTaskView({super.key});

  Future<void> _selectDate(BuildContext context, CreateTaskController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDateTime.value, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, 
              onPrimary: Colors.white,
              onSurface: Colors.black, 
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.setSelectedDate(picked); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
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
            _buildTextField(
              hint: 'Masukkan Nama Misi', 
              controller: controller.titleController
            ),
            
            const SizedBox(height: 20),
            const Text('Steps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            _buildTextField(hint: 'Masukkan Sub Task', controller: controller.stepController),
            const SizedBox(height: 10),
            _buildTextField(hint: 'Masukkan Sub Task',),
            const SizedBox(height: 10),
            _buildTextField(hint: 'Masukkan Sub Task',),
            
            const SizedBox(height: 20),
            const Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            Obx(() {
                var _ = controller.selectedDateTime.value; 
                return _buildTextField(
                    hint: 'Pilih Tanggal Deadline (Contoh: 16 Oct)', 
                    suffixIcon: Icons.calendar_today, 
                    isRedIcon: true,
                    controller: controller.dateController,
                    onTap: () => _selectDate(context, controller), 
                    readOnly: true,
                );
            }),
            
            const SizedBox(height: 20),
            const Text('Reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            
            _buildReminderBox(),
            
            const SizedBox(height: 30),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
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
                
                // --- TOMBOL CONTINUE DENGAN LOADING STATE ---
                Obx(() => Expanded(
                  child: ElevatedButton(
                    // Tombol dinonaktifkan jika sedang loading
                    onPressed: controller.isLoading.isTrue 
                      ? null 
                      : () => controller.submitTask(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: controller.isLoading.isTrue
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Continue'),
                  ),
                )),
                // --- END TOMBOL LOADING ---
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildTextField
  Widget _buildTextField({
    required String hint, 
    IconData? suffixIcon, 
    bool isRedIcon = false,
    TextEditingController? controller,
    VoidCallback? onTap, 
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
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

  // Widget _buildReminderBox
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Berikan Notifikasi Setiap:', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 10),
                
                Obx(() => Wrap( 
                  spacing: 8,
                  children: List.generate(controller.daysLabel.length, (index) {
                    bool isSelected = controller.selectedDays[index];
            
                    return GestureDetector(
                      onTap: () => controller.toggleDay(index),
                      child: Container(
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          controller.daysLabel[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                )),
              ],
            ),
          ),
          
          const SizedBox(width: 10),
          const Icon(Icons.notifications_active_outlined, color: Colors.orange, size: 30),
        ],
      ),
    );
  }
}