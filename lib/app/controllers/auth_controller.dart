import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../firebase_options.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Simpan instance GoogleSignIn agar dapat mengontrol signOut/disconnect
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Rx<User?> currentUser = Rx<User?>(null);
  final isSigningIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_auth.authStateChanges());
  }

  Future<void> initFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  Future<UserCredential?> signInWithGoogle(
      {bool forceNewAccount = false}) async {
    try {
      isSigningIn.value = true;

      // Opsional: paksa tampilkan pemilih akun dengan menghapus sesi sebelumnya
      if (forceNewAccount) {
        try {
          await _googleSignIn.disconnect();
        } catch (_) {}
        await _googleSignIn.signOut();
      }

      // 1. Pilih akun Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isSigningIn.value = false;
        return null; // batal
      }

      // 2. Ambil token autentikasi
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Buat credential untuk Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Login ke Firebase
      final UserCredential result =
          await _auth.signInWithCredential(credential);
      return result;
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString());
      return null;
    } finally {
      isSigningIn.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.disconnect();
    } catch (_) {}
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
