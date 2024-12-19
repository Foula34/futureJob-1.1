import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:future_job/services/job_ask_service.dart';
import 'package:future_job/models/job_ask_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:future_job/services/jobs_service.dart';

class JobApplicationPage extends StatefulWidget {
  final JobAskModel jobItem;

  const JobApplicationPage({super.key, required this.jobItem});

  @override
  State<JobApplicationPage> createState() => _JobApplicationPageState();
}

class _JobApplicationPageState extends State<JobApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String? selectedCV;
  String? selectedCoverLetter;

  final JobAskService _jobAskService = JobAskService();
  final JobsService _jobsService = JobsService();
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> pickCV() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          selectedCV = result.files.single.name;
        });
      }
    } catch (e) {
      _showErrorMessage('Erreur lors de la sélection du CV: $e');
    }
  }

  Future<void> pickCoverLetter() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        setState(() {
          selectedCoverLetter = result.files.single.name;
        });
      }
    } catch (e) {
      _showErrorMessage(
          'Erreur lors de la sélection de la lettre de motivation: $e');
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _sendJobApplication() async {
    if (_isLoading) return;

    try {
      setState(() {
        _isLoading = true;
      });

      if (_formKey.currentState?.validate() ?? false) {
        // Vérification de l'utilisateur
        final User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          throw Exception('Vous devez être connecté pour postuler');
        }

        // Récupération des détails du job
        print('Récupération des détails du job: ${widget.jobItem.jobId}');
        Map<String, dynamic>? jobDetails =
            await _jobAskService.getJobDetails(widget.jobItem.jobId);

        if (jobDetails == null) {
          throw Exception('Impossible de récupérer les détails du poste');
        }
        print('Détails du job récupérés: $jobDetails');

        // Création de la demande
        JobAskModel jobAsk = JobAskModel(
          title: jobDetails['jobTitle'] ?? 'Titre indisponible',
          date: DateTime.now().toString(),
          status: 'En attente',
          applyLink: jobDetails['applyLink'] ?? '',
          jobId: widget.jobItem.jobId,
          userId: currentUser.uid,
        );

        // Ajout de la candidature
        print('Ajout de la candidature...');
        await _jobAskService.addJobApplication(jobAsk);

        // Mise à jour des candidatures dans la collection jobs
        print('Récupération des candidatures existantes...');
        List<Map<String, dynamic>> currentApplications =
            await _jobsService.getJobApplications(widget.jobItem.jobId);

        print('Candidatures actuelles: $currentApplications');

        // Ajout de la nouvelle candidature
        currentApplications.add({
          'userId': currentUser.uid,
          'date': jobAsk.date,
          'status': jobAsk.status,
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        });

        // Mise à jour dans Firestore
        print('Mise à jour des candidatures dans Firestore...');
        await _jobsService.updateJobApplications(
            widget.jobItem.jobId, currentApplications);

        _showSuccessMessage('Candidature envoyée avec succès !');
        await _openEmailClient();

        if (mounted) {
          Navigator.pushNamed(context, '/home');
        }
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la candidature: $e');
      _showErrorMessage('Erreur lors de l\'envoi de la candidature: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _openEmailClient() async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: widget.jobItem.applyLink,
        queryParameters: {
          'subject': 'Application pour le poste ${widget.jobItem.title}',
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
        throw Exception('Impossible d\'ouvrir l\'application mail');
      }
    } catch (e) {
      _showErrorMessage('Erreur lors de l\'ouverture du client mail: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, '/home'),
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
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre nom complet',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    if (!value.contains('@')) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Numéro de téléphone',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: 'Entrez votre numéro de téléphone',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: pickCV,
                  child: const Text('Choisir un CV'),
                ),
                if (selectedCV != null) ...[
                  const SizedBox(height: 8),
                  Text('CV sélectionné : $selectedCV'),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: pickCoverLetter,
                  child: const Text('Choisir une Lettre de Motivation'),
                ),
                if (selectedCoverLetter != null) ...[
                  const SizedBox(height: 8),
                  Text(
                      'Lettre de motivation sélectionnée : $selectedCoverLetter'),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendJobApplication,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Envoyer ma candidature'),
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
