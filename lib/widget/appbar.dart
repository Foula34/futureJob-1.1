import 'package:flutter/material.dart';
import 'package:future_job/authentication/profile_screen.dart';
import 'package:future_job/models/user_model.dart';

AppBar buildAppBar(int currentIndex, BuildContext context, User user) {
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
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(user: user)),
              );
            },
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/me.jpg'),
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
    // case 3:
    //   return AppBar(
    //     centerTitle: true,
    //     leading: IconButton(
    //       onPressed: () {
    //         Navigator.pushNamed(context, '/home');
    //       },
    //       icon: const Icon(Icons.arrow_back_ios),
    //     ),
    //     title: Text(
    //       'Emplois postulé',
    //       style: GoogleFonts.roboto(
    //         fontSize: 24.0,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //     backgroundColor: Colors.white,
    //   );
    default:
      return AppBar();
  }
}
