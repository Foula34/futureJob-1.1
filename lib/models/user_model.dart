class User {
  // Informations de base
  final String id;
  String name;
  String email;
  String phoneNumber;
  String address;
  
  // Préférences de job
  String preferredJobType; // Par exemple : CDI, CDD, Stage
  String preferredIndustry; // Par exemple : Informatique, Santé, Éducation
  String preferredLocation; // Par exemple : Conakry, Kindia, Labé
  List<String> skills; // Compétences spécifiques que l'utilisateur possède
  
  // Réseaux sociaux
  String linkedIn;
  String twitter;
  String instagram;
  
  // Constructeur
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.preferredJobType = '',
    this.preferredIndustry = '',
    this.preferredLocation = '',
    this.skills = const [],
    this.linkedIn = '',
    this.twitter = '',
    this.instagram = '',
  });
  
  // Méthode pour mettre à jour les préférences
  void updatePreferences({
    String? jobType,
    String? industry,
    String? location,
    List<String>? newSkills,
  }) {
    if (jobType != null) preferredJobType = jobType;
    if (industry != null) preferredIndustry = industry;
    if (location != null) preferredLocation = location;
    if (newSkills != null) skills = newSkills;
  }
  
  // Afficher les informations de l'utilisateur
  @override
  String toString() {
    return 'Utilisateur: $name\nEmail: $email\nTéléphone: $phoneNumber\nAdresse: $address\nPréférences: $preferredJobType dans $preferredIndustry à $preferredLocation\nCompétences: ${skills.join(", ")}';
  }
}