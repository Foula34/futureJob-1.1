class AppNotification {
  final String id; // Identifiant unique de la notification
  final String userId; // Identifiant de l'utilisateur qui reçoit la notification
  final String title; // Titre de la notification
  final String body; // Corps de la notification
  final DateTime timestamp; // Horodatage de la notification

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.timestamp,
  });

  // Méthode pour convertir une notification en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Méthode pour créer une notification à partir de JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}