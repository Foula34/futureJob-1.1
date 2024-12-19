import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importer Firebase Auth
import 'package:future_job/models/job_ask_model.dart';

class JobAskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode pour ajouter une demande d'emploi à la collection "jobask"
  Future<void> addJobApplication(JobAskModel jobAskModel) async {
    try {
      // Récupérer l'ID de l'utilisateur actuel
      String userId = _auth.currentUser?.uid ?? '';

      await _firestore.collection('jobask').add({
        'title': jobAskModel.title,
        'date': jobAskModel.date,
        'status': jobAskModel.status,
        'applyLink': jobAskModel.applyLink,
        'jobId': jobAskModel.jobId,
        'userId': userId, // Ajouter l'ID de l'utilisateur
      });
      print("Demande d'emploi ajoutée avec succès");
    } catch (e) {
      print("Erreur lors de l'ajout de la demande : $e");
    }
  }

  // Méthode pour récupérer toutes les demandes d'emploi pour l'utilisateur connecté
  Future<List<JobAskModel>> getJobApplications() async {
    List<JobAskModel> jobApplications = [];
    try {
      // Récupérer l'ID de l'utilisateur actuel
      String userId = _auth.currentUser?.uid ?? '';

      // Récupérer uniquement les candidatures de l'utilisateur
      QuerySnapshot snapshot = await _firestore
          .collection('jobask')
          .where('userId', isEqualTo: userId) // Filtrer par userId
          .get();

      for (var doc in snapshot.docs) {
        jobApplications
            .add(JobAskModel.fromFirestore(doc.data() as Map<String, dynamic>));
      }
      return jobApplications;
    } catch (e) {
      print("Erreur lors de la récupération des demandes : $e");
      return [];
    }
  }

  // Méthode pour mettre à jour le statut d'une demande d'emploi
  Future<void> updateJobStatus(String jobId, String newStatus) async {
    try {
      // Mise à jour du document dans Firestore
      await _firestore.collection('jobask').doc(jobId).update({
        'status': newStatus,
      });
      print("Statut mis à jour avec succès");
    } catch (e) {
      print("Erreur lors de la mise à jour du statut : $e");
    }
  }

  // Méthode pour récupérer les détails d'un emploi depuis la collection "jobs"
  Future<Map<String, dynamic>?> getJobDetails(String jobId) async {
    try {
      // Récupérer les informations de l'emploi depuis la collection "jobs"
      DocumentSnapshot jobSnapshot =
          await _firestore.collection('jobs').doc(jobId).get();

      if (jobSnapshot.exists) {
        // Récupérer toutes les informations nécessaires pour la demande
        return {
          'companyLogo': jobSnapshot['companyLogo'] ?? '',
          'jobTitle': jobSnapshot['jobTitle'] ?? '',
          'companyName': jobSnapshot['companyName'] ?? '',
          'employmentType': jobSnapshot['employmentType'] ?? '',
          'salary': jobSnapshot['salary'] ?? '',
          'location': jobSnapshot['location'] ?? '',
          'applyLink': jobSnapshot['applyLink'] ?? '',
          'isFavorite': jobSnapshot['isFavorite'] ?? false,
          'jobDescription': jobSnapshot['jobDescription'] ?? '',
          'requirements': List<String>.from(jobSnapshot['requirements'] ?? []),
        };
      } else {
        print("Emploi non trouvé");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération des détails de l'emploi : $e");
      return null;
    }
  }
}
