import 'package:flutter/material.dart';
import 'package:future_job/models/message_model.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  // Liste des messages avec le nouveau modèle
  List<Message> messages = [
    Message(
      id: 'msg1',
      senderId: 'user1',
      senderName: 'Ahmed',
      receiverId: 'user2',
      content: 'Hello bro',
      imageLink: 'https://picsum.photos/seed/pic1/200/300',
      timestamp: DateTime.now(),
    ),
    Message(
      id: 'msg2',
      senderId: 'user2',
      senderName: 'Sarah',
      receiverId: 'user1',
      content: 'How are you?',
      imageLink: 'https://picsum.photos/seed/pic2/200/300',
      timestamp: DateTime.now(),
    ),
    Message(
      id: 'msg3',
      senderId: 'user3',
      senderName: 'John',
      receiverId: 'user1',
      content: 'See you soon!',
      imageLink: 'https://picsum.photos/seed/pic3/200/300',
      timestamp: DateTime.now(),
    ),
    Message(
      id: 'msg4',
      senderId: 'user4',
      senderName: 'Alice',
      receiverId: 'user1',
      content: 'Good morning!',
      imageLink: 'https://picsum.photos/seed/pic4/200/300',
      timestamp: DateTime.now(),
    ),
    Message(
      id: 'msg5',
      senderId: 'user5',
      senderName: 'Michael',
      receiverId: 'user1',
      content: 'Did you finish the project?',
      imageLink: 'https://picsum.photos/seed/pic5/200/300',
      timestamp: DateTime.now(),
    ),
    Message(
      id: 'msg6',
      senderId: 'user6',
      senderName: 'Emily',
      receiverId: 'user1',
      content: 'Let’s grab lunch!',
      imageLink: 'https://picsum.photos/seed/pic6/200/300',
      timestamp: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(message.imageLink),
            ),
            title: Text(message.senderName),
            subtitle: Text(
                message.content), // Utilisation de content au lieu de message
            trailing: CircleAvatar(
              radius: 10.0,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        },
      ),
    );
  }
}
