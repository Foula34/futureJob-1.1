import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Méthode pour s'inscrire avec email, mot de passe, et photo de profil
  Future<User?> signUpWithEmail(String email, String password, String username,
      {String? profileImageUrl}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Enregistrement des informations dans Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': username,
          'email': email,
          'profileImageUrl':
              profileImageUrl ?? '', // Ajout de la photo de profil
          'createdAt': FieldValue.serverTimestamp(),
          'preferredJobType': '',
          'preferredIndustry': '',
          'preferredLocation': '',
          'skills': [],
        });
      }
      return user;
    } catch (e) {
      print('Error during sign up: $e');
      return null;
    }
  }

  // Méthode pour mettre à jour la photo de profil de l'utilisateur
  Future<void> updateProfileImage(String userId, File imageFile) async {
    try {
      // Créer un chemin de stockage unique pour l'image de profil
      String filePath = 'profile_pictures/$userId.jpg';

      // Télécharger l'image vers Firebase Storage
      TaskSnapshot uploadTask = await _storage.ref(filePath).putFile(imageFile);

      // Obtenir l'URL de l'image téléchargée
      String imageUrl = await uploadTask.ref.getDownloadURL();

      // Mettre à jour l'URL dans Firestore
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });

      print('Photo de profil mise à jour avec succès!');
    } catch (e) {
      print('Erreur lors de la mise à jour de la photo de profil: $e');
    }
  }

  // Méthode pour se connecter avec email et mot de passe
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during sign in: $e');
      return null;
    }
  }

  // Méthode pour se déconnecter
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  // Méthode pour obtenir l'utilisateur actuel
  User? getCurrentUser() {
    try {
      return _auth.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Nouvelle méthode : Récupérer les informations d'un utilisateur depuis Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = getCurrentUser();
      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        } else {
          print('User document does not exist');
          return null;
        }
      } else {
        print('No user currently logged in');
        return null;
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}
