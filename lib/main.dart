import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:future_job/authentication/profile_screen.dart';
import 'package:future_job/authentication/signin.dart';
import 'package:future_job/authentication/signup.dart';
import 'package:future_job/authentication/welcome_screen.dart';
import 'package:future_job/firebase_options.dart';
import 'package:future_job/home/job_detail_screen.dart';
import 'package:future_job/home/notification_screen.dart';
import 'package:future_job/home/settings_screen.dart';
import 'package:future_job/home/subscribe_job_screen.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/models/user_model.dart';
import 'package:future_job/widget/drawer.dart';
import 'package:future_job/widget/filter_bottom_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialisation de Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Exemple d'objet JobItem
    JobItem jobItem = JobItem(
      jobTitle: 'Développeur Flutter',
      companyLogo: 'https://example.com/logo.png',
      companyName: 'TechCorp',
      salary: '2000 €',
      location: 'Conakry, Guinée',
      jobDescription: 'Développer des applications Flutter...',
      applyLink: 'recrutement@techcorp.com', id: '', // Lien email pour postuler
    );

    CustumUser currentUser = CustumUser(
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
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => ProfileScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/notification': (context) => const NotificationScreen(),
        '/sign': (context) => const SignScreen(),
        '/setting': (context) => const SettingsScreen(),
        '/home': (context) => JobHomePage(user: currentUser),
        '/drawer': (context) => const DrawerWidget(),
        '/details': (context) {
          final JobItem jobItem =
              ModalRoute.of(context)!.settings.arguments as JobItem;
          return JobDetailsPage(jobItem: jobItem);
        },
        '/subscribe': (context) {
          return JobApplicationPage(jobItem: jobItem); // Passage de jobItem
        },
      },
    );
  }
}
