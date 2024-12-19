class JobItem {
  final String id; // Identifiant unique du job
  final String companyLogo;
  final String jobTitle;
  final String companyName;
  final String salary;
  final String location;
  final bool isFavorite;
  final String jobDescription;
  final List<String> requirements;
  final String employmentType;
  final String applyLink;
  final List<Map<String, dynamic>>
      applications; // Nouvelle propriété pour les candidatures

  JobItem({
    required this.id,
    required this.companyLogo,
    required this.jobTitle,
    required this.salary,
    this.companyName = '',
    this.location = '',
    this.isFavorite = false,
    this.jobDescription = '',
    this.employmentType = 'Temps Plein',
    this.applyLink = 'fofanafoula70@gmail.com',
    List<String>? requirements,
    required this.applications, // Champ applications ajouté
  }) : requirements = requirements ?? [];

  // Factory pour faciliter la conversion depuis Firestore
  factory JobItem.fromFirestore(Map<String, dynamic> data, String documentId) {
    return JobItem(
      id: documentId,
      companyLogo: data['companyLogo'] ?? '',
      jobTitle: data['jobTitle'] ?? '',
      companyName: data['companyName'] ?? '',
      salary: data['salary'] ?? '',
      location: data['location'] ?? '',
      isFavorite: data['isFavorite'] ?? false,
      jobDescription: data['jobDescription'] ?? '',
      employmentType: data['employmentType'] ?? 'Temps Plein',
      applyLink: data['applyLink'] ?? 'fofanafoula70@gmail.com',
      requirements: List<String>.from(data['requirements'] ?? []),
      applications: List<Map<String, dynamic>>.from(
          data['applications'] ?? []), // Récupérer les candidatures
    );
  }

  get jobId => null;
}
