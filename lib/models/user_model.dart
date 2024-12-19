import 'package:cloud_firestore/cloud_firestore.dart';

class CustumUser {
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

  // Photo de profil
  String profileImageUrl; // Ajout du champ pour la photo de profil

  // Constructeur
  CustumUser({
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
    this.profileImageUrl = '', // Initialisation de profileImageUrl
  });

  // Méthode pour créer un utilisateur à partir de Firestore
  factory CustumUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CustumUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      address: data['address'] ?? '',
      preferredJobType: data['preferredJobType'] ?? '',
      preferredIndustry: data['preferredIndustry'] ?? '',
      preferredLocation: data['preferredLocation'] ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      linkedIn: data['linkedIn'] ?? '',
      twitter: data['twitter'] ?? '',
      instagram: data['instagram'] ?? '',
      profileImageUrl:
          data['profileImageUrl'] ?? '', // Charger l'URL de la photo de profil
    );
  }

  // Méthode pour convertir un utilisateur en Map pour Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'preferredJobType': preferredJobType,
      'preferredIndustry': preferredIndustry,
      'preferredLocation': preferredLocation,
      'skills': skills,
      'linkedIn': linkedIn,
      'twitter': twitter,
      'instagram': instagram,
      'profileImageUrl': profileImageUrl, // Ajouter l'URL de la photo de profil
    };
  }
}
