//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- BAGIAN FOTO PROFIL ---
            Center(
              child: Stack(
                children: [
                  // Lingkaran Foto
                  Obx(() {
                    // Priority: local selected file > saved URL from Firestore > default icon
                    ImageProvider? imageProvider;
                    if (controller.profileImageBytes.value != null) {
                      imageProvider =
                          MemoryImage(controller.profileImageBytes.value!);
                    } else if (controller.photoUrl.value.isNotEmpty) {
                      final val = controller.photoUrl.value;
                      if (val.startsWith('data:image')) {
                        try {
                          final parts = val.split(',');
                          final bytes = base64Decode(parts.last);
                          imageProvider = MemoryImage(bytes);
                        } catch (e) {
                          // fallback to NetworkImage if decoding fails
                          imageProvider = NetworkImage(val);
                        }
                      } else {
                        imageProvider = NetworkImage(val);
                      }
                    }

                    return CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.person,
                              size: 60, color: Colors.grey)
                          : null,
                    );
                  }),
                  // Tombol Kamera Kecil
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _showImagePickerOptions(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- INPUT NAMA ---
            _buildTextField(
              label: "Full Name",
              controller: controller.nameController,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            // --- INPUT TANGGAL LAHIR ---
            // Menggunakan ReadOnly true agar tidak muncul keyboard, tapi muncul date picker
            GestureDetector(
              onTap: () => controller.selectDate(context),
              child: AbsorbPointer(
                // Mencegah keyboard muncul
                child: _buildTextField(
                  label: "Date of Birth",
                  controller: controller.dateController,
                  icon: Icons.calendar_today,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- TOMBOL SAVE ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => controller.saveProfile(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET HELPER TEXTFIELD ---
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.blue),
            hintText: "Enter $label",
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  // --- BOTTOM SHEET PILIH GALERI / KAMERA ---
  void _showImagePickerOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Change Profile Picture",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionItem(
                  icon: Icons.camera_alt,
                  label: "Camera",
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.pickImage(ImageSource.camera);
                  },
                ),
                _buildOptionItem(
                  icon: Icons.image,
                  label: "Gallery",
                  onTap: () {
                    Navigator.of(context).pop();
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
