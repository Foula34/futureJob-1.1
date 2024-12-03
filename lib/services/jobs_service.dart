import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:future_job/models/job_item_model.dart';

class JobsService {
  final CollectionReference _jobsCollection =
      FirebaseFirestore.instance.collection('jobs');

  Future<List<JobItem>> fetchJobs() async {
    try {
      QuerySnapshot snapshot = await _jobsCollection.get();
      print('Fetched ${snapshot.docs.length} jobs');
      return snapshot.docs.map((doc) {
        print('Job data: ${doc.data()}');
        return JobItem(
          companyLogo: doc['companyLogo'] ?? '',
          jobTitle: doc['jobTitle'] ?? '',
          companyName: doc['companyName'] ?? '',
          employmentType: doc['employmentType'] ?? '',
          salary: doc['salary'] ?? '',
          location: doc['location'] ?? '',
          isFavorite: doc['isFavorite'] ?? false,
          jobDescription: doc['jobDescription'] ?? '',
          requirements: List<String>.from(doc['requirements'] ?? []),
        );
      }).toList();
    } catch (e) {
      print('Error fetching jobs: $e');
      return [];
    }
  }
}
