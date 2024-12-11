import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/widget/custom_button.dart';

class JobApplicationPage extends StatefulWidget {
  final JobItem jobItem; // JobItem en paramètre

  const JobApplicationPage({super.key, required this.jobItem});

  @override
  _JobApplicationPageState createState() => _JobApplicationPageState();
}

class _JobApplicationPageState extends State<JobApplicationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers pour récupérer les données saisies
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Variables pour stocker les fichiers choisis
  String? selectedCV;
  String? selectedCoverLetter;

  // Fonction pour choisir un fichier (CV)
  Future<void> pickCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedCV = result.files.single.name;
      });
    }
  }

  // Fonction pour choisir un fichier (Lettre de motivation)
  Future<void> pickCoverLetter() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        selectedCoverLetter = result.files.single.name;
      });
    }
  }

  // Fonction pour ouvrir l'email avec les champs pré-remplis
  void _openEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: widget.jobItem.applyLink, // Email du recruteur
      queryParameters: {
        'subject': 'Application pour le poste ${widget.jobItem.jobTitle}',
        'body': '''
Nom: ${nameController.text}
Email: ${emailController.text}
Téléphone: ${phoneController.text}

CV: ${selectedCV ?? 'Aucun CV'}
Lettre de motivation: ${selectedCoverLetter ?? 'Aucune lettre'}
        '''
            .trim(),
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Impossible d\'ouvrir l\'application mail'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Postuler pour le poste'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nom complet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre nom complet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre adresse email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre adresse email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Veuillez entrer une adresse email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Téléphone',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre numéro de téléphone';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'CV (PDF, DOC, DOCX)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    CustomButton(
                      text: 'Choisir un fichier',
                      onPressed: pickCV,
                      isLoading: false,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        selectedCV != null
                            ? selectedCV!
                            : 'Aucun fichier sélectionné',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lettre de motivation (PDF, DOC, DOCX)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    CustomButton(
                      text: 'Choisir un fichier',
                      onPressed: pickCoverLetter,
                      isLoading: false,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        selectedCoverLetter != null
                            ? selectedCoverLetter!
                            : 'Aucun fichier sélectionné',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: CustomButton(
                    text: 'Envoyer la candidature',
                    onPressed:
                        _openEmailClient, // Ouvrir Gmail avec les champs pré-remplis
                    isLoading: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
