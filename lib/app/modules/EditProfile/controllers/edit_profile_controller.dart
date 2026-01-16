import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:image/image.dart' as img;
import '../../../controllers/profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileController extends GetxController {
  // Controller TextFields
  final nameController = TextEditingController();
  final dateController = TextEditingController();

  // Variabel untuk menyimpan bytes gambar (local) dan URL (Firestore)
  Rx<Uint8List?> profileImageBytes = Rx<Uint8List?>(null);
  final isUploadingPhoto = false.obs;
  final photoUrl = ''.obs; // Store URL from Firestore

  final ImagePicker _picker = ImagePicker();
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
      if (doc.exists && doc['photoUrl'] != null) {
        final url = doc['photoUrl'] as String;
        if (url.isNotEmpty) {
          photoUrl.value = url;
        }
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
        final bytes = await image.readAsBytes();
        profileImageBytes.value = bytes;
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
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Get.snackbar(
        "Error",
        "User tidak ditemukan. Silakan login ulang.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      // 1) Encode photo to base64 and save into Firestore (no Storage)
      String uploadedPhotoUrl = photoUrl.value; // Start with existing value
      if (profileImageBytes.value != null) {
        isUploadingPhoto.value = true;
        try {
          final bytes = profileImageBytes.value!;
          // Decode and resize/compress using `image` package
          try {
            final original = img.decodeImage(bytes);
            if (original == null) {
              Get.snackbar('Warning', 'Gagal memproses gambar.',
                  backgroundColor: Colors.orange, colorText: Colors.white);
              return;
            }

            img.Image processed = original;

            // Resize if larger than target
            const int maxDim = 800;
            if (processed.width > maxDim || processed.height > maxDim) {
              // calculate scaled dimensions maintaining aspect ratio
              final double ratio = processed.width > processed.height
                  ? maxDim / processed.width
                  : maxDim / processed.height;
              final int targetWidth = (processed.width * ratio).round();
              // use named width param to resize and let height be computed
              processed = img.copyResize(processed, width: targetWidth);
            }

            // Encode as JPEG with quality to reduce size
            List<int> jpeg = img.encodeJpg(processed, quality: 75);

            // If still too large, try lower quality once
            const int firestoreLimit = 1048487; // ~1MB
            if (jpeg.length > firestoreLimit) {
              jpeg = img.encodeJpg(processed, quality: 60);
            }

            if (jpeg.length > firestoreLimit) {
              print('Compressed photo still too large: ${jpeg.length} bytes');
              Get.snackbar('Warning',
                  'Foto terlalu besar untuk disimpan di Firestore. Gunakan Storage atau pilih foto lebih kecil.',
                  backgroundColor: Colors.orange, colorText: Colors.white);
              return;
            }

            final b64 = base64Encode(jpeg);
            uploadedPhotoUrl = 'data:image/jpeg;base64,$b64';
            photoUrl.value = uploadedPhotoUrl;
            print('Photo encoded to base64, length=${b64.length}');
          } catch (e) {
            print('Image processing failed: $e');
            // fallback to raw bytes encode (may fail due to size)
            final b64 = base64Encode(bytes);
            uploadedPhotoUrl = 'data:image/jpeg;base64,$b64';
            photoUrl.value = uploadedPhotoUrl;
          }

          // Optionally update FirebaseAuth.photoURL (may store data URL)
          try {
            await user.updatePhotoURL(uploadedPhotoUrl);
          } catch (e) {
            print('Warning: updatePhotoURL failed: $e');
          }
        } catch (e) {
          print('Photo encode error: $e');
          Get.snackbar('Warning', 'Gagal memproses foto: $e',
              backgroundColor: Colors.orange, colorText: Colors.white);
          return; // stop if photo processing fails
        } finally {
          isUploadingPhoto.value = false;
        }
      }

      // 2) Update FirebaseAuth.displayName
      if (newName.isNotEmpty) {
        await user.updateDisplayName(newName);
        await user.reload();
        print('Display name updated: $newName');
      }

      // 3) Simpan ke state lokal
      if (newName.isNotEmpty) profile.name.value = newName;
      if (newDob.isNotEmpty) profile.birthDate.value = newDob;
      if (uploadedPhotoUrl.isNotEmpty) {
        profile.photoUrl.value = uploadedPhotoUrl;
      }

      // 4) Persist ALL changes to Firestore users/{uid}
      try {
        final updateData = {
          'name': newName.isNotEmpty ? newName : profile.name.value,
          'birthDate': newDob.isNotEmpty ? newDob : profile.birthDate.value,
          'email': user.email,
          'uid': user.uid,
        };

        // ALWAYS save photoUrl if we have it
        if (uploadedPhotoUrl.isNotEmpty) {
          updateData['photoUrl'] = uploadedPhotoUrl;
        }

        print('Saving to Firestore: $updateData');
        await _firestore.collection('users').doc(user.uid).set(
              updateData,
              SetOptions(merge: true),
            );
        print('Firestore save successful');

        // Reload to verify
        await _loadProfilePhoto();
      } catch (e) {
        print('Firestore save error: $e');
        Get.snackbar('Warning', 'Gagal menyimpan ke server: $e',
            backgroundColor: Colors.orange, colorText: Colors.white);
        return; // Stop if Firestore save fails
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
      print('Save profile error: $e');
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
