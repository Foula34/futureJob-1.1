import 'package:flutter/material.dart';
import 'package:future_job/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  // Champs de saisie
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _preferredJobTypeController =
      TextEditingController();
  final TextEditingController _preferredIndustryController =
      TextEditingController();
  final TextEditingController _preferredLocationController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  Future<void> _loadCurrentUserData() async {
    try {
      final userData = await _authService.getUserData();
      if (userData != null) {
        setState(() {
          _nameController.text = userData['name'] ?? '';
          _preferredJobTypeController.text = userData['preferredJobType'] ?? '';
          _preferredIndustryController.text =
              userData['preferredIndustry'] ?? '';
          _preferredLocationController.text =
              userData['preferredLocation'] ?? '';
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _authService.updateUserData(
          _nameController.text.trim(),
          _preferredJobTypeController.text.trim(),
          _preferredIndustryController.text.trim(),
          _preferredLocationController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil mis à jour avec succès")),
        );
        Navigator.pop(context);
      } catch (e) {
        print('Erreur lors de la mise à jour des données: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la mise à jour")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Modifier le profil",
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(
                controller: _nameController,
                label: "Nom complet",
                icon: Icons.person,
                validator: (value) =>
                    value!.isEmpty ? "Ce champ est requis" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _preferredJobTypeController,
                label: "Type de travail préféré",
                icon: Icons.work,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _preferredIndustryController,
                label: "Secteur préféré",
                icon: Icons.business,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _preferredLocationController,
                label: "Emplacement préféré",
                icon: Icons.location_on,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text("Enregistrer"),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.roboto(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
