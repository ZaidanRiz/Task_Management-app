import 'package:cloud_firestore/cloud_firestore.dart'; // Tambahkan ini
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instance Firestore
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  final Rx<User?> currentUser = Rx<User?>(null);
  final isSigningIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_auth.authStateChanges());
  }

  // --- FUNGSI LOGIN EMAIL (Solusi untuk Garis Merah) ---
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      isSigningIn.value = true;
      UserCredential res = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return res.user;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Gagal', e.message ?? 'Terjadi kesalahan',
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } finally {
      isSigningIn.value = false;
    }
  }

  // --- FUNGSI SIGN UP (Simpan Nama ke Database) ---
  Future<User?> signUp(String name, String email, String password) async {
    try {
      isSigningIn.value = true;
      
      // 1. Buat user di Auth
      UserCredential res = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Simpan data tambahan ke Firestore
      if (res.user != null) {
        await _firestore.collection('User').doc(res.user!.uid).set({
          'uid': res.user!.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return res.user;
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Sign Up Gagal', e.message ?? 'Terjadi kesalahan',
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } finally {
      isSigningIn.value = false;
    }
  }

  // --- FUNGSI GOOGLE SIGN IN ---
  Future<UserCredential?> signInWithGoogle({bool forceNewAccount = false}) async {
    try {
      isSigningIn.value = true;
      if (forceNewAccount) {
        try { await _googleSignIn.disconnect(); } catch (_) {}
        await _googleSignIn.signOut();
      }
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isSigningIn.value = false;
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString());
      return null;
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<void> signOut() async {
    try { await _googleSignIn.disconnect(); } catch (_) {}
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}