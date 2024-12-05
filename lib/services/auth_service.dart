import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fonction d'inscription
  Future<User?> signUpWithEmail(String email, String password, String username,
      {String? profileImageUrl}) async {
    try {
      // Création d'un nouvel utilisateur
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
      // Connexion de l'utilisateur
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
      // Récupérer les informations de l'utilisateur à partir de Firestore
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>?;
      }
    }
    return null;
  }

  // Fonction pour mettre à jour l'image de profil
  Future<void> updateProfileImage(String userId, File imageFile) async {
    try {
      // Téléchargement de l'image dans Firebase Storage
      String filePath = 'profile_pictures/$userId.jpg';
      TaskSnapshot uploadTask = await _storage.ref(filePath).putFile(imageFile);
      String imageUrl = await uploadTask.ref.getDownloadURL();

      // Mise à jour de l'URL de l'image dans Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });
    } catch (e) {
      print('Erreur lors de la mise à jour de l\'image de profil: $e');
    }
  }

  // Fonction pour se déconnecter
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Fonction pour récupérer l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Fonction pour réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Erreur lors de la réinitialisation du mot de passe: $e');
    }
  }

  // Fonction pour changer le mot de passe de l'utilisateur
  Future<void> changePassword(String oldPassword, String newPassword) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Re-authentification avec l'ancien mot de passe
        AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, password: oldPassword);

        await user.reauthenticateWithCredential(credential);

        // Changer le mot de passe
        await user.updatePassword(newPassword);
      } catch (e) {
        print('Erreur lors du changement du mot de passe: $e');
      }
    }
  }

  // Fonction pour mettre à jour les informations de l'utilisateur (nom, etc.)
  Future<void> updateUserData(String name, String preferredJobType,
      String preferredIndustry, String preferredLocation) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        // Mise à jour des informations de l'utilisateur dans Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'name': name,
          'preferredJobType': preferredJobType,
          'preferredIndustry': preferredIndustry,
          'preferredLocation': preferredLocation,
        });
      } catch (e) {
        print('Erreur lors de la mise à jour des données utilisateur: $e');
      }
    }
  }
}
