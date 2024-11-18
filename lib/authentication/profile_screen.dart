import 'package:flutter/material.dart';
import 'package:future_job/home/settings_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/images/me.jpg'),
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
          _buildListTile('Numéro de téléphone', widget.user.phoneNumber),
          _buildListTile('Adresse', widget.user.address,
              trailing: const Icon(Icons.location_on)),
          _buildListTile(
            'Préférences de travail',
            'Type: ${widget.user.preferredJobType}\nSecteur: ${widget.user.preferredIndustry}\nLocalisation: ${widget.user.preferredLocation}',
          ),
          _buildListTile('Candidatures en cours', '2 candidatures en attente',
              trailing: const Icon(Icons.work_outline)),
          _buildListTile(
            'Événements et webinaires',
            'Prochain événement : Webinaire sur le CV',
            trailing: const Icon(Icons.event),
            onTap: () {
              // Naviguer vers la page des événements
            },
          ),
          _buildListTile(
            'Réseaux sociaux',
            'LinkedIn: ${widget.user.linkedIn}\nTwitter: ${widget.user.twitter}\nInstagram: ${widget.user.instagram}',
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blue),
            title: const Text('Paramètres',
                style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle,
      {Icon? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
            trailing: trailing,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Action de modification du profil
      },
      icon: const Icon(Icons.edit),
      label: const Text('Modifier le profil'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4C41A3),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
    );
  }
}
