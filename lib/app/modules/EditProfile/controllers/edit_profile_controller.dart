import 'dart:io'; // Import untuk File
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileController extends GetxController {
  // Controller TextFields
  final nameController = TextEditingController();
  final dateController = TextEditingController();

  // Variabel untuk menyimpan File Gambar
  Rx<File?> profileImage = Rx<File?>(null);
  final isUploadingPhoto = false.obs;

  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _initializeProfile();
  }

  // --- INITIALIZE PROFILE WITH FRESH DATA FROM FIREBASE ---
  Future<void> _initializeProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Reload to get latest displayName from Firebase Auth
        await user.reload();
        final displayName = user.displayName ?? 'User';
        nameController.text = displayName;
      }
    } catch (e) {
      print('Error initializing profile: $e');
      // Fallback: use ProfileController value
      final profile = Get.find<ProfileController>();
      nameController.text = profile.name.value.isNotEmpty
          ? profile.name.value
          : (FirebaseAuth.instance.currentUser?.displayName ?? 'User');
    }

    // Set date of birth
    final profile = Get.find<ProfileController>();
    dateController.text = profile.birthDate.value.isNotEmpty
        ? profile.birthDate.value
        : "24-11-2025";

    // Load saved photo URL from Firestore if exists
    _loadProfilePhoto();
  }

  // --- LOAD SAVED PHOTO FROM FIRESTORE ---
  Future<void> _loadProfilePhoto() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists &&
          doc['photoUrl'] != null &&
          (doc['photoUrl'] as String).isNotEmpty) {
        // Photo URL saved; we could load it via NetworkImage if needed
        // For now, just display if user re-picks or it's shown via FirebaseAuth.photoUrl
      }
    } catch (e) {
      print('Error loading profile photo: $e');
    }
  }

  // --- LOGIKA AMBIL GAMBAR ---
  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        profileImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil gambar: $e");
    }
  }

  // --- LOGIKA PILIH TANGGAL ---
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format tanggal menjadi DD-MM-YYYY
      dateController.text = DateFormat('dd-MM-yyyy').format(picked);
    }
  }

  // --- SIMPAN PROFIL ---
  Future<void> saveProfile() async {
    final profile = Get.find<ProfileController>();
    final newName = nameController.text.trim();
    final newDob = dateController.text.trim();

    try {
      // 1) Update FirebaseAuth.displayName (jika user ada)
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && newName.isNotEmpty) {
        await user.updateDisplayName(newName);
      }

      // 2) Simpan ke state lokal (agar Settings langsung merefleksikan perubahan)
      if (newName.isNotEmpty) profile.name.value = newName;
      if (newDob.isNotEmpty) profile.birthDate.value = newDob;

      // 3) Upload photo to Firebase Storage if a new photo was selected
      String? photoUrl;
      if (profileImage.value != null && user != null) {
        isUploadingPhoto.value = true;
        try {
          final fileName =
              'profile_${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final ref = _storage.ref().child('profile_photos').child(fileName);

          await ref.putFile(profileImage.value!);
          photoUrl = await ref.getDownloadURL();

          // Also update FirebaseAuth.photoURL
          await user.updatePhotoURL(photoUrl);
          await user.reload();
        } catch (e) {
          Get.snackbar('Warning', 'Gagal upload foto: $e',
              backgroundColor: Colors.orange, colorText: Colors.white);
        } finally {
          isUploadingPhoto.value = false;
        }
      }

      // 4) Persist changes to Firestore users/{uid}
      try {
        if (user != null) {
          final updateData = {
            'name': newName,
            'birthDate': newDob,
          };
          if (photoUrl != null) {
            updateData['photoUrl'] = photoUrl;
          }

          await _firestore.collection('users').doc(user.uid).set(
                updateData,
                SetOptions(merge: true),
              );
        }
      } catch (e) {
        // Non-fatal: show a warning but keep app usable
        Get.snackbar('Warning', 'Gagal menyimpan ke server: $e',
            backgroundColor: Colors.orange, colorText: Colors.white);
      }

      Get.snackbar(
        "Berhasil",
        "Profil berhasil diperbarui!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );

      // Kembali ke tampilan Settings setelah delay singkat
      await Future.delayed(const Duration(milliseconds: 600));
      Get.offNamed('/settings');
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Tidak dapat menyimpan profil: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
