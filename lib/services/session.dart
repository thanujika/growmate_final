import '../models/user.dart';

class Session {
  static String? token;
  static AppUser? user;

  // ✅ Save session
  static Future<void> save(String newToken, AppUser newUser) async {
    token = newToken;
    user = newUser;
  }

  // ✅ Update only user data (FIX FOR YOUR ERROR)
  static void updateUser(AppUser newUser) {
    user = newUser;
  }

  // ✅ Clear session
  static void clear() {
    token = null;
    user = null;
  }
}