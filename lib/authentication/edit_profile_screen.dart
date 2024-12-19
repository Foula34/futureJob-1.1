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
        title: const Text("Modifier le profil"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom complet"),
                validator: (value) =>
                    value!.isEmpty ? "Ce champ est requis" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preferredJobTypeController,
                decoration:
                    const InputDecoration(labelText: "Type de travail préféré"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preferredIndustryController,
                decoration: const InputDecoration(labelText: "Secteur préféré"),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _preferredLocationController,
                decoration:
                    const InputDecoration(labelText: "Emplacement préféré"),
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _saveProfile,
                      child: const Text("Enregistrer"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
