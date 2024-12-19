import 'package:flutter/material.dart';
import 'package:future_job/authentication/edit_profile_screen.dart';
import 'package:future_job/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _authService.getUserData();
      if (data != null) {
        setState(() {
          _userData = data;
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_userData == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Aucune donnée utilisateur disponible.",
            style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
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
        Text(
          _userData!['name'],
          style: GoogleFonts.roboto(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          _userData!['preferredJobType'] ?? "Type de travail non défini",
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
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
              'Type de travail préféré', _userData!['preferredJobType'] ?? ''),
          _buildListTile(
              'Secteur préféré', _userData!['preferredIndustry'] ?? ''),
          _buildListTile('Emplacement', _userData!['preferredLocation'] ?? ''),
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
      onPressed: () async {
        // Naviguer vers l'écran d'édition et attendre la mise à jour
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
        );

        // Recharger les données après modification
        _loadUserData();
      },
      child: const Text("Modifier le profil"),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
