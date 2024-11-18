import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_job/authentication/profile_screen.dart';
import 'package:future_job/authentication/signin.dart';
import 'package:future_job/authentication/signup.dart';
import 'package:future_job/authentication/welcome_screen.dart';
import 'package:future_job/firebase_options.dart';
import 'package:future_job/home/home_screen.dart';
import 'package:future_job/home/job_detail_screen.dart';
import 'package:future_job/home/notification_screen.dart';
import 'package:future_job/home/settings_screen.dart';
import 'package:future_job/home/subscribe_job_screen.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/models/user_model.dart';
import 'package:future_job/widget/drawer.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Nécessaire pour l'initialisation Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialisation de Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User currentUser = User(
      name: 'Foula Fofana',
      email: 'fofanafoula70@gmail.com',
      phoneNumber: '+224 624366897',
      address: 'Tombolia cité, Conakry',
      preferredJobType: 'Développeur Mobile',
      preferredIndustry: 'Technologie',
      preferredLocation: 'Guinée',
      linkedIn: 'linkedin.com/in/foulafofana',
      twitter: '@foulafofana',
      instagram: '@foula_insta',
      id: '12',
    );

    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(Colors.blue.value),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(), // Écran de connexion
        '/profile': (context) => ProfileScreen(user: currentUser),
        '/welcome': (context) => const WelcomeScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/sign': (context) => const SignScreen(), // Inscription
        '/setting': (context) => const SettingsScreen(),
        '/home': (context) => JobHomePage(user: currentUser),
        '/drawer': (context) => const DrawerWidget(),
        '/details': (context) {
          final JobItem jobItem =
              ModalRoute.of(context)!.settings.arguments as JobItem;
          return JobDetailsPage(jobItem: jobItem);
        },
        '/subscribe': (context) => const JobApplicationPage(),
      },
    );
  }
}
