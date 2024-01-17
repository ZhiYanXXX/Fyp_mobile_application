import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Function to handle user login
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = credential.user;

      if (user != null) {
        // Store or update the user's information in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set(
            {
              'lastSignInTime': DateTime.now(),
              // Add other fields as necessary
            },
            SetOptions(
                merge:
                    true)); // merge: true ensures existing data isn't overwritten

        return user;
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth Exceptions
      String message =
          e.message ?? 'An error occurred. Please try again later.';
      Get.snackbar('Error', message, backgroundColor: Colors.red);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with Email & Password.',
          backgroundColor: Colors.red);
    }
    return null;
  }

  // Function to handle user registration
  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;

      if (user != null) {
        // Store the user's information in Firestore
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'email': user.email,
          'name': name,
        });

        return user;
      }
    } on FirebaseAuthException catch (e) {
      // Use GetX's snackbar to show error message
      String message =
          e.message ?? 'An error occurred. Please try again later.';
      Get.snackbar('Error', message, backgroundColor: Colors.red);
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again later',
          backgroundColor: Colors.red);
    }
    return null;
  }
}
