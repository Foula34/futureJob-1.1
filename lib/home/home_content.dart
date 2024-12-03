import 'package:flutter/material.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/services/jobs_service.dart';
import 'package:future_job/widget/job_card.dart';
import 'package:future_job/widget/job_post.dart';
import 'package:future_job/widget/section_title.dart';
import 'package:future_job/models/user_model.dart';

class HomeContent extends StatefulWidget {
  final User user;

  const HomeContent({super.key, required this.user});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late Future<List<JobItem>> _jobsFuture;
  late Future<List<JobItem>> _recommendedJobsFuture;
  late Future<List<JobItem>> _newJobsFuture;

  @override
  void initState() {
    super.initState();
    _jobsFuture = JobsService().fetchJobs(); // Section jobs populaires
    _recommendedJobsFuture = JobsService().fetchJobs(); // Recommandé pour vous
    _newJobsFuture = JobsService().fetchJobs(); // Nouvelles offres
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Jobs populaires'),
          const SizedBox(height: 10),

          // FutureBuilder pour afficher les jobs populaires
          FutureBuilder<List<JobItem>>(
            future: _jobsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucun emploi trouvé.'));
              }

              final jobItems = snapshot.data!;

              return SingleChildScrollView(
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
              );
            },
          ),

          const SizedBox(height: 20),

          const SectionTitle(title: 'Recommandé pour vous'),
          const SizedBox(height: 10),

          // FutureBuilder pour afficher les emplois recommandés
          FutureBuilder<List<JobItem>>(
            future: _recommendedJobsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucun emploi recommandé.'));
              }

              final recommendedJobs = snapshot.data!;

              return SingleChildScrollView(
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
              );
            },
          ),

          const SizedBox(height: 20),

          const SectionTitle(title: 'Nouvelles offres'),
          const SizedBox(height: 10),

          // FutureBuilder pour afficher les nouvelles offres avec JobPost
          FutureBuilder<List<JobItem>>(
            future: _newJobsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Erreur : ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucune nouvelle offre.'));
              }

              final newJobs = snapshot.data!;

              return Column(
                children: newJobs.map((jobItem) {
                  return JobPost(jobItem: jobItem); // Utilisation de JobPost
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
