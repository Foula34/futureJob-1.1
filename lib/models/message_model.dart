class Message {
  final String id; 
  final String senderId;
  final String senderName; 
  final String receiverId; 
  final String content; 
  final String imageLink; 
  final DateTime timestamp; 

  // Constructeur
  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.content,
    required this.imageLink,
    required this.timestamp,
  });

  // Méthode pour convertir un message en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'receiverId': receiverId,
      'content': content,
      'imageLink': imageLink,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Méthode pour créer un message à partir de JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      receiverId: json['receiverId'],
      content: json['content'],
      imageLink: json['imageLink'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}