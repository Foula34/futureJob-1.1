import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:future_job/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fonction d'inscription
  Future<User?> signUpWithEmail(String email, String password, String username,
      {String? profileImageUrl}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Sauvegarde des informations utilisateur dans Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': username,
          'email': email,
          'profileImageUrl': profileImageUrl ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'preferredJobType': '',
          'preferredIndustry': '',
          'preferredLocation': '',
          'skills': [],
        });
      }
      return user;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      return null;
    }
  }

  // Fonction de connexion
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential.user;
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      return null;
    }
  }

  // Fonction de récupération des données utilisateur
  Future<Map<String, dynamic>?> getUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Mettre à jour les informations utilisateur
  Future<void> updateUserData(
    String name,
    String preferredJobType,
    String preferredIndustry,
    String preferredLocation,
  ) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Mettre à jour les informations utilisateur dans Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'preferredJobType': preferredJobType,
          'preferredIndustry': preferredIndustry,
          'preferredLocation': preferredLocation,
        });
      } catch (e) {
        print('Erreur lors de la mise à jour des données utilisateur: $e');
        throw e; // Re-throw l'erreur pour être géré dans la vue
      }
    }
  }

  // Mettre à jour les préférences utilisateur
  Future<void> updateUserPreferences(String preferredJobType,
      String preferredIndustry, String preferredLocation) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'preferredJobType': preferredJobType,
          'preferredIndustry': preferredIndustry,
          'preferredLocation': preferredLocation,
        });
      } catch (e) {
        print('Erreur lors de la mise à jour des préférences utilisateur: $e');
      }
    }
  }
}
