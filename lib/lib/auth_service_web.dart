import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Mock Google Sign-In for Web
  Future<bool> signInWithGoogle() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      await prefs.setBool('is_guest', false);
      await prefs.setString('user_name', 'Google User');
      await prefs.setString('user_email', 'user@gmail.com');
      await prefs.setString('user_photo', '');
      
      return true;
    } catch (e) {
      print('Sign-In Error: $e');
      return false;
    }
  }

  // Guest sign in
  Future<void> signInAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_guest', true);
    await prefs.setBool('is_logged_in', false);
    await prefs.setString('user_name', 'Guest User');
    await prefs.setString('user_email', '');
    await prefs.setString('user_photo', '');
  }

  // Sign out
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}