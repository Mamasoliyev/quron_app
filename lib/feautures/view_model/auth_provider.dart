import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quron_app/feautures/models/user_model.dart';
import 'package:quron_app/feautures/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  UserModel? _user;
  UserModel? get user => _user;

  // 🔹 Sign up
  Future<bool> signUp(
    String email,
    String password,
    String confirmPassword,
  ) async {
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      errorMessage = "Barcha maydonlarni to'ldiring";
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      errorMessage = "Parollar mos emas";
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      notifyListeners();

      final user = await _authService.signUpWithEmail(email, password);
      _user = user;

      isLoading = false;
      notifyListeners();

      return user != null;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔹 Google sign in
  Future<bool> googleSignIn() async {
    try {
      isLoading = true;
      notifyListeners();

      final user = await _authService.signInWithGoogle();
      _user = user;

      isLoading = false;
      notifyListeners();

      return user != null;
    } catch (e) {
      errorMessage = e.toString();
      log(errorMessage.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 🔹 Email login
  Future<bool> loginWithEmail(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Email va parolni to‘ldiring";
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final user = await _authService.loginWithEmail(email, password);
      _user = user;

      isLoading = false;
      notifyListeners();

      return user != null;
    } catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // 🔹 Foydalanuvchini olish (App start yoki HomeScreen uchun)
  Future<void> loadUserData() async {
  _user = await _authService.getCurrentUserData();
  notifyListeners();
}

  // 🔹 Logout
Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    final googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.disconnect(); // ✅ bu joyi to‘g‘ri
    }

    _user = null;
    notifyListeners();
  }


}
