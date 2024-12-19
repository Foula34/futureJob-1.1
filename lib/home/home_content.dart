import 'package:flutter/material.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/models/user_model.dart';
import 'package:future_job/services/jobs_service.dart';
import 'package:future_job/widget/job_card.dart';
import 'package:future_job/widget/section_title.dart';
import 'package:future_job/widget/job_post.dart';

class HomeContent extends StatelessWidget {
  final CustumUser user; // Assurez-vous que le type est CustomUser
  final JobsService jobsService;

  HomeContent({required this.user, required this.jobsService});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: 'Jobs populaires'),
          const SizedBox(height: 10),

          // StreamBuilder pour afficher les jobs populaires (favoris uniquement)
          StreamBuilder<List<JobItem>>(
            stream: jobsService
                .getFavoriteJobsStream(), // Filtrage des emplois favoris dans le service
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

          // StreamBuilder pour afficher les emplois recommandés
          StreamBuilder<List<JobItem>>(
            stream: jobsService.getRecommendedJobsStream(
                user), // Passer le user de type CustomUser
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

          // StreamBuilder pour afficher les nouvelles offres
          StreamBuilder<List<JobItem>>(
            stream: jobsService
                .getAllJobsStream(), // Tous les emplois, y compris ceux non favoris
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
