import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:future_job/home/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  // Fonction pour permettre à l'utilisateur de choisir une image de profil
  Future<void> _pickImage() async {
    // Utilisation de file_picker pour le web
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });

      // Téléchargement de l'image sur Firebase Storage
      try {
        // Créer une référence pour le fichier dans Firebase Storage
        String fileName = DateTime.now()
            .millisecondsSinceEpoch
            .toString(); // Utiliser le timestamp pour nommer l'image
        Reference storageRef =
            FirebaseStorage.instance.ref().child('profile_images/$fileName');

        // Télécharger l'image sur Firebase Storage
        UploadTask uploadTask = storageRef.putFile(_image!);

        // Attendre que le téléchargement soit terminé
        TaskSnapshot taskSnapshot = await uploadTask;

        // Récupérer l'URL de l'image téléchargée
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Mettre à jour Firestore avec l'URL de l'image
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.user.id)
            .update({
          'profileImageUrl':
              imageUrl, // Met à jour l'URL de l'image dans Firestore
        });

        // Mettre à jour l'URL dans l'objet utilisateur local
        setState(() {
          widget.user.profileImageUrl = imageUrl;
        });
      } catch (e) {
        print('Erreur lors du téléchargement de l\'image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
        elevation: 2, // Légère ombre pour plus de profondeur
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
        // Afficher l'image de profil ou une image par défaut
        _image == null
            ? CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                    widget.user.profileImageUrl.isNotEmpty
                        ? widget.user.profileImageUrl
                        : 'https://example.com/default-profile-image.jpg'),
              )
            : CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(_image!),
              ),
        const SizedBox(height: 16),
        Text(
          widget.user.name,
          style: GoogleFonts.roboto(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          ' ${widget.user.preferredJobType}',
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
        ),
        // Ajouter un bouton pour changer la photo de profil
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
      tooltip:
          'Action ${icon.toString()}', // Ajout d'un tooltip pour plus d'information
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
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildListTile('Email', widget.user.email),
          _buildListTile(
              'Type de travail préféré', widget.user.preferredJobType),
          _buildListTile('Secteur préféré', widget.user.preferredIndustry),
          _buildListTile('Emplacement ', widget.user.preferredLocation),
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
