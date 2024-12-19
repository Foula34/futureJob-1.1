class JobAskModel {
  final String title;
  final String date;
  final String status;
  final String applyLink;
  final String jobId;

  JobAskModel({
    required this.title,
    required this.date,
    required this.status,
    required this.applyLink,
    required this.jobId,
  });

  // Conversion d'un document Firestore en JobAskModel
  factory JobAskModel.fromFirestore(Map<String, dynamic> data) {
    return JobAskModel(
      title: data['title'],
      date: data['date'],
      status: data['status'],
      applyLink: data['applyLink'],
      jobId: data['jobId'],
    );
  }
}
