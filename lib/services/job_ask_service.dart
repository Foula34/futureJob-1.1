import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_job/models/job_ask_model.dart';

class JobAskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Méthode pour ajouter une demande d'emploi à la collection "jobask"
  Future<void> addJobApplication(JobAskModel jobAskModel) async {
    try {
      await _firestore.collection('jobask').add({
        'title': jobAskModel.title,
        'date': jobAskModel.date,
        'status': jobAskModel.status,
        'applyLink': jobAskModel.applyLink,
        'jobId': jobAskModel.jobId,
      });
      print("Demande d'emploi ajoutée avec succès");
    } catch (e) {
      print("Erreur lors de l'ajout de la demande : $e");
    }
  }

  // Méthode pour récupérer toutes les demandes d'emploi depuis Firestore
  Future<List<JobAskModel>> getJobApplications() async {
    List<JobAskModel> jobApplications = [];
    try {
      QuerySnapshot snapshot = await _firestore.collection('jobask').get();
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
}
