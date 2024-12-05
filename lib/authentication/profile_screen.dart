import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:future_job/home/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../models/user_model.dart';
import '../../services/auth_service.dart'; // Assurez-vous que le chemin d'importation est correct.

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required User user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;
  Map<String, dynamic>? _userData;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Récupérer les données de l'utilisateur actif via AuthService
      Map<String, dynamic>? userData = await AuthService().getUserData();

      if (userData != null) {
        setState(() {
          _userData = userData;
          _currentUser = AuthService().getCurrentUser() as User?;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
    }
  }

  Future<void> _pickImage() async {
    // Utilisation de file_picker pour le web
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });

      try {
        String fileName = DateTime.now()
            .millisecondsSinceEpoch
            .toString(); // Utiliser le timestamp pour nommer l'image
        Reference storageRef =
            FirebaseStorage.instance.ref().child('profile_images/$fileName');

        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask;

        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.id)
            .update({
          'profileImageUrl': imageUrl,
        });

        setState(() {
          _userData!['profileImageUrl'] = imageUrl;
        });
      } catch (e) {
        print('Erreur lors du téléchargement de l\'image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userData == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profil",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              _buildUserInfo(),
              const SizedBox(height: 24),
              _buildEditProfileButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        _image == null
            ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    _userData!['profileImageUrl'].isNotEmpty
                        ? _userData!['profileImageUrl']
                        : 'https://example.com/default-profile-image.jpg'),
              )
            : CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(_image!),
              ),
        const SizedBox(height: 16),
        Text(
          _userData!['name'],
          style: GoogleFonts.roboto(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          _userData!['preferredJobType'],
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.camera_alt),
          label: Text("Changer la photo"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
            Icons.email, () => {/* Action pour envoyer un email */}),
        _buildActionButton(Icons.phone, () => {/* Action pour appeler */}),
        _buildActionButton(
            Icons.star, () => {/* Action pour ajouter aux favoris */}),
        _buildActionButton(Icons.share, () => {/* Action pour partager */}),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.blue),
      onPressed: onPressed,
      tooltip: 'Action ${icon.toString()}',
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTile('Email', _userData!['email']),
          _buildListTile(
              'Type de travail préféré', _userData!['preferredJobType']),
          _buildListTile('Secteur préféré', _userData!['preferredIndustry']),
          _buildListTile('Emplacement', _userData!['preferredLocation']),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title:
          Text(title, style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: GoogleFonts.roboto(color: Colors.grey)),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton(
      onPressed: () {
        // Action pour éditer le profil
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingsScreen()));
      },
      child: Text("Modifier le profil"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
