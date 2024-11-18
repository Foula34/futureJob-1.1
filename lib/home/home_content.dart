import 'package:flutter/material.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/utils/list.dart';
import 'package:future_job/widget/job_card.dart';
import 'package:future_job/widget/job_post.dart';
import 'package:future_job/widget/section_title.dart';
import 'package:future_job/models/user_model.dart';

class HomeContent extends StatefulWidget {
  final User user; // Profil utilisateur pour les préférences de recommandation

  const HomeContent({super.key, required this.user});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedLocation;
  String? selectedSalary;
  String? selectedJobType;

  final List<String> locations = [
    'Toronto, Canada',
    'New York, USA',
    'Paris, France'
  ];
  final List<String> salaries = ['< \$2000', '\$2000 - \$4000', '> \$4000'];

  @override
  Widget build(BuildContext context) {
    // Création de deux emplois spécifiques pour la section recommandée
    final List<JobItem> recommendedJobs = [
      JobItem(
        companyLogo: 'assets/images/Nimba hub.png',
        jobTitle: 'Développeur Flutter',
        companyName: 'Tech Innovators',
        salary: '2000000 Gnf - 4000000 Gnf',
        location: 'Conakry, Guinée',
        isFavorite: true,
        jobDescription: 'Développement d\'applications mobiles avec Flutter.',
        requirements: ['2+ ans d\'expérience', 'Connaissance en Flutter'],
      ),
      JobItem(
        companyLogo: 'assets/images/google.jpg',
        jobTitle: 'Analyste de données',
        companyName: 'Data Insights',
        salary: '2000000 Gnf - 4000000 Gnf',
        location: 'Dakar, Sénégal',
        isFavorite: false,
        jobDescription: 'Analyse de données et création de rapports.',
        requirements: ['3+ ans d\'expérience', 'Maîtrise des outils BI'],
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section "Jobs populaires"
          const SectionTitle(title: 'Jobs populaires'),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: jobItems.map((jobItem) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: jobItem,
                    );
                  },
                  child: JobCard(jobItem: jobItem),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Section "Recommandé pour vous"
          const SectionTitle(title: 'Recommandé pour vous'),
          const SizedBox(height: 10),
          recommendedJobs.isNotEmpty
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: recommendedJobs.map((jobItem) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: jobItem,
                          );
                        },
                        child: JobCard(jobItem: jobItem),
                      );
                    }).toList(),
                  ),
                )
              : const Center(
                  child: Text(
                    'Aucun emploi recommandé pour le moment',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          const SizedBox(height: 20),

          // Section "Nouvelles offres"
          const SectionTitle(title: 'Nouvelles offres'),
          const SizedBox(height: 10),
          Column(
            children: jobItems.map((jobItem) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: jobItem,
                  );
                },
                child: JobPost(jobItem: jobItem),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
