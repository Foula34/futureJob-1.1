import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/models/user_model.dart'; // Assurez-vous d'importer CustomUser

class JobsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer tous les emplois favoris (avec isFavorite = true) pour la section 'Jobs populaires'
  Stream<List<JobItem>> getFavoriteJobsStream() {
    try {
      return _firestore
          .collection('jobs')
          .where('isFavorite', isEqualTo: true) // Filtrer les emplois favoris
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return _mapJobWithApplications(doc);
        }).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des emplois: $e');
      return Stream.value([]); // Renvoie une liste vide en cas d'erreur
    }
  }

  // Récupérer tous les emplois, indépendamment de leur statut favori pour les autres sections
  Stream<List<JobItem>> getAllJobsStream() {
    try {
      return _firestore.collection('jobs').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return _mapJobWithApplications(doc);
        }).toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des emplois: $e');
      return Stream.value([]); // Renvoie une liste vide en cas d'erreur
    }
  }

  // Récupérer les emplois recommandés en fonction des préférences de l'utilisateur
  Stream<List<JobItem>> getRecommendedJobsStream(CustumUser customUser) {
    try {
      return _firestore
          .collection('users')
          .doc(customUser.id) // Utilisez customUser.id, pas firebaseUser.uid
          .snapshots()
          .asyncMap((userDocSnapshot) async {
        if (userDocSnapshot.exists) {
          Map<String, dynamic> userData =
              userDocSnapshot.data() as Map<String, dynamic>;

          // Récupération des préférences de l'utilisateur
          String? preferredJobType = userData['preferredJobType'];
          String? preferredIndustry = userData['preferredIndustry'];
          String? preferredLocation = userData['preferredLocation'];

          Query query = _firestore.collection('jobs');

          // Ajouter des filtres pour chaque préférence (si elles existent)
          if (preferredJobType != null && preferredJobType.isNotEmpty) {
            query = query.where('jobType', isEqualTo: preferredJobType);
          }
          if (preferredIndustry != null && preferredIndustry.isNotEmpty) {
            query = query.where('industry', isEqualTo: preferredIndustry);
          }
          if (preferredLocation != null && preferredLocation.isNotEmpty) {
            query = query.where('location', isEqualTo: preferredLocation);
          }

          // Retourner les résultats filtrés
          var snapshot = await query.get();
          return snapshot.docs.map((doc) {
            return _mapJobWithApplications(doc);
          }).toList();
        }
        return []; // Si aucun utilisateur n'est trouvé, retourner une liste vide
      });
    } catch (e) {
      print('Erreur lors de la récupération des emplois recommandés: $e');
      return Stream.value([]); // Renvoie une liste vide en cas d'erreur
    }
  }

  // Mettre à jour le statut du favori d'un emploi
  Future<void> updateFavoriteStatus(String jobId, bool isFavorite) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'isFavorite': isFavorite,
      });
    } catch (e) {
      print('Erreur lors de la mise à jour du statut favori: $e');
      rethrow; // Relance l'erreur pour la capturer dans l'appelant
    }
  }

  // Méthode pour mapper un job avec ses candidatures
  JobItem _mapJobWithApplications(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;

    // Récupérer les applications
    List<Map<String, dynamic>> applications =
        List<Map<String, dynamic>>.from(data['applications'] ?? []);

    return JobItem(
      id: doc.id,
      companyLogo: data['companyLogo'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      companyName: data['companyName'] ?? '',
      employmentType: data['employmentType'] ?? '',
      salary: data['salary'] ?? '',
      location: data['location'] ?? '',
      applyLink: data['applyLink'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      jobDescription: data['jobDescription'] ?? '',
      requirements: List<String>.from(data['requirements'] ?? []),
      applications: applications, // Ajouter les applications récupérées
    );
  }

  // Récupérer les candidatures d'un emploi spécifique
  Future<List<Map<String, dynamic>>> getJobApplications(String jobId) async {
    try {
      // Récupérer le document de l'emploi avec l'ID spécifié
      DocumentSnapshot jobDoc =
          await _firestore.collection('jobs').doc(jobId).get();

      if (jobDoc.exists) {
        // Récupérer les applications du champ "applications" du document
        var data = jobDoc.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> applications =
            List<Map<String, dynamic>>.from(data['applications'] ?? []);
        return applications; // Retourner la liste des candidatures
      } else {
        print('Emploi non trouvé');
        return []; // Si l'emploi n'existe pas, retourner une liste vide
      }
    } catch (e) {
      print('Erreur lors de la récupération des candidatures: $e');
      return []; // Renvoie une liste vide en cas d'erreur
    }
  }

  // Mettre à jour les candidatures d'un emploi spécifique
  Future<void> updateJobApplications(
      String jobId, List<Map<String, dynamic>> applications) async {
    try {
      // Mettre à jour le champ 'applications' dans le document de l'emploi
      await _firestore.collection('jobs').doc(jobId).update({
        'applications': applications, // Mettre à jour la liste des candidatures
      });
    } catch (e) {
      print('Erreur lors de la mise à jour des candidatures: $e');
      rethrow; // Relance l'erreur pour pouvoir la capturer plus haut dans la pile d'appels
    }
  }
}
