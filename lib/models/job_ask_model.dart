class JobAskModel {
  final String title;
  final String date;
  final String status;
  final String applyLink;
  final String jobId;
  final String userId;

  JobAskModel({
    required this.title,
    required this.date,
    required this.status,
    required this.applyLink,
    required this.jobId,
    required this.userId,
  });

  // Convertir les données Firestore en modèle
  factory JobAskModel.fromFirestore(Map<String, dynamic> firestoreData) {
    return JobAskModel(
      title: firestoreData['title'] ?? '',
      date: firestoreData['date'] ?? '',
      status: firestoreData['status'] ?? '',
      applyLink: firestoreData['applyLink'] ?? '',
      jobId: firestoreData['jobId'] ?? '',
      userId: firestoreData['userId'] ?? '',
    );
  }

  // Convertir le modèle en Map pour l'ajout dans Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'status': status,
      'applyLink': applyLink,
      'jobId': jobId,
      'userId': userId,
    };
  }
}
