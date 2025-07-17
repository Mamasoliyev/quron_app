import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quron_app/feautures/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); 

  Future<UserModel?> signUpWithEmail(String email, String password) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      final userModel = UserModel.fromFirebase(user);
      await _firestore.collection("users").doc(user.uid).set(userModel.toMap());
      return userModel;
    }
    return null;
  }


  Future<UserModel?> signInWithGoogle() async {
    try {
      // 🔒 Faqat tizimga kirgan bo‘lsa disconnect qil
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await _firestore
            .collection("users")
            .doc(user.uid)
            .get();
        if (!userDoc.exists) {
          await _firestore
              .collection("users")
              .doc(user.uid)
              .set(UserModel.fromFirebase(user).toMap());
        }
        return UserModel.fromFirebase(user);
      }

      return null;
    } catch (e) {
      log('Google SignIn Error: $e');
      return null;
    }
  }




  Future<UserModel?> loginWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user != null) {
      return UserModel.fromFirebase(user);
    }
    return null;
  }

  // ✅ ADD THIS:
  Future<UserModel?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final userDoc = await _firestore.collection("users").doc(user.uid).get();
    if (userDoc.exists) {
      final data = userDoc.data()!;
      return UserModel(
        uid: data['uid'],
        email: data['email'],
        displayName: data['displayName'],
        photoUrl: data['photoURL'],
      );
    }
    return null;
  }
}
