import 'package:flutter/material.dart';
import 'package:future_job/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart'; // Pour partager l'application

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final AuthService _authService = AuthService();

  String username = '';
  String email = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Récupérer les données de l'utilisateur
  Future<void> _fetchUserData() async {
    try {
      final userData = await _authService.getUserData();
      if (userData != null) {
        setState(() {
          username = userData['name'] ?? '';
          email = userData['email'] ?? '';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 50.0, left: 18.0, right: 18.0, bottom: 50.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Affichage du nom de l'utilisateur
            Text(
              username.isEmpty ? 'Nom d\'utilisateur' : username,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 3.0),
            // Affichage de l'email
            Text(
              email.isEmpty ? 'Email' : email,
              style: GoogleFonts.roboto(
                color: Colors.grey,
                fontSize: 15.0,
              ),
            ),
            const SizedBox(height: 20.0),

            // Option pour modifier le profil
            _buildDrawerItem(
              context,
              icon: Icons.person_rounded,
              text: 'Modifier le Profil',
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),

            const SizedBox(height: 20.0),

            // Option pour les paramètres
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              text: 'Paramètre',
              onTap: () => Navigator.pushNamed(context, '/setting'),
            ),

            const SizedBox(height: 20.0),

            // Option pour partager l'application
            _buildDrawerItem(
              context,
              icon: Icons.favorite,
              text: "Partager l'application",
              onTap: () => _shareApp(), // Appel de la méthode _shareApp
            ),

            const SizedBox(height: 20.0),

            // Option pour se déconnecter
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              text: 'Se déconnecter',
              iconColor: Colors.red[200],
              onTap: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour construire les éléments du drawer
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? Colors.black),
          const SizedBox(width: 10.0),
          Text(
            text,
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  // Méthode pour partager l'application
  void _shareApp() {
    final String appLink =
        'https://example.com/download'; // Lien vers l'application
    final String message = 'Découvrez cette application incroyable : $appLink';
    Share.share(message);
  }
}
