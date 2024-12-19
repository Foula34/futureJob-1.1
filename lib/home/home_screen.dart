import 'package:flutter/material.dart';
import 'package:future_job/home/home_content.dart';
import 'package:future_job/home/job_ask.dart';
import 'package:future_job/home/notification_screen.dart';
import 'package:future_job/services/jobs_service.dart';
import 'package:future_job/widget/appbar.dart';
import 'package:future_job/widget/drawer.dart';
import 'package:future_job/models/user_model.dart'; // Importez votre modèle User

class JobHomePage extends StatefulWidget {
  final CustumUser
      user; // Utilisateur personnalisé pour passer aux différentes pages

  const JobHomePage({super.key, required this.user});

  @override
  State<JobHomePage> createState() => _JobHomePageState();
}

class _JobHomePageState extends State<JobHomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialisation des pages avec l'utilisateur en paramètre pour HomeContent
    _pages = [
      HomeContent(
        user: widget.user,
        jobsService: JobsService(),
      ), // Passez l'utilisateur personnalisé ici
      const NotificationScreen(),
      const JobAsk(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(_currentIndex, context,
          widget.user), // Passez l'utilisateur personnalisé ici
      drawer: _currentIndex == 0 ? const DrawerWidget() : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Jobs',
          ),
        ],
      ),
    );
  }
}
