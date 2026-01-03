import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_task_controller.dart';

class CreateTaskView extends GetView<CreateTaskController> {
  const CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
            TextField(
              controller: controller.titleController,
              decoration: _inputDecoration('Masukkan Nama Misi'),
            ),
            const SizedBox(height: 20),
            const Text('Steps',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Obx(() => Column(
                  children: List.generate(
                    controller.stepControllers.length,
                    (i) => Padding(
                      padding: EdgeInsets.only(
                          bottom: i == controller.stepControllers.length - 1
                              ? 0
                              : 10),
                      child: TextField(
                        controller: controller.stepControllers[i],
                        decoration:
                            _inputDecoration('Masukkan Sub Task').copyWith(
                          suffixIcon: controller.stepControllers.length > 1
                              ? IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.redAccent),
                                  onPressed: () =>
                                      controller.removeStepField(i),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                )),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: controller.addStepField,
              icon: const Icon(Icons.add, color: Colors.blue),
              label: const Text('Tambah Sub Task',
                  style: TextStyle(color: Colors.blue)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: controller.dateController,
              readOnly: true,
              decoration:
                  _inputDecoration('Masukkan Tanggal Deadline (d MMM yyyy)')
                      .copyWith(
                suffixIcon:
                    const Icon(Icons.calendar_today, color: Colors.redAccent),
              ),
              onTap: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.selectedDateTime.value,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 5),
                );
                if (picked != null) controller.setSelectedDate(picked);
              },
            ),
            const SizedBox(height: 20),
            const Text('Reminder',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),

            // 3. Panggil Widget Reminder Box yang sudah diupdate
            _buildReminderBox(),

            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.shade100,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => controller.submitTask(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.lightBlueAccent)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 1.5)),
      );

  // 4. Widget Reminder Box yang sudah Interaktif
  Widget _buildReminderBox() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Berikan Notifikasi Setiap:',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const SizedBox(height: 10),

              // Generate tombol hari berdasarkan list
              Obx(() {
                final labels = controller.daysLabel;
                final selected = controller.selectedDays;
                return Row(
                  children: List.generate(labels.length, (index) {
                    final isOn = selected[index];
                    return GestureDetector(
                      onTap: () => controller.toggleDay(index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 30,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isOn ? Colors.blue : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          labels[index],
                          style: TextStyle(
                            color: isOn ? Colors.white : Colors.grey,
                            fontWeight:
                                isOn ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ],
          ),
          const Icon(Icons.notifications_active_outlined,
              color: Colors.orange, size: 30),
        ],
      ),
    );
  }
}
