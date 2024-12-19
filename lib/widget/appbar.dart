import 'package:flutter/material.dart';
import 'package:future_job/authentication/profile_screen.dart';
import 'package:future_job/models/user_model.dart'; // Assurez-vous que vous avez bien importé votre modèle User

AppBar buildAppBar(int currentIndex, BuildContext context, CustumUser user) {
  switch (currentIndex) {
    case 0:
      return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent, // Couleur de fond
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      );
    case 1:
      return AppBar(
        actions: const [Icon(Icons.search)],
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
      );
    case 2:
      return AppBar(
        title: const Text("Emplois"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
      );
    default:
      return AppBar();
  }
}
