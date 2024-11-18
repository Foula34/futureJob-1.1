import 'package:flutter/material.dart';

class JobAsk extends StatefulWidget {
  const JobAsk({super.key});

  @override
  State<JobAsk> createState() => _JobAskState();
}

class _JobAskState extends State<JobAsk> {
  final List<Map<String, dynamic>> jobs = [
    {'title': 'Développeur Flutter', 'date': '2024-10-01', 'status': 'Accepté'},
    {'title': 'Ingénieur DevOps', 'date': '2024-09-28', 'status': 'En attente'},
    {'title': 'Analyste Sécurité', 'date': '2024-09-20', 'status': 'Refusé'},
    {'title': 'Chef de Projet IT', 'date': '2024-09-15', 'status': 'Accepté'},
  ];

  // Mapping des états aux couleurs et icônes
  Color getStatusColor(String status) {
    switch (status) {
      case 'Accepté':
        return Colors.green; // Couleur pour l'état Accepté
      case 'En attente':
        return Colors.orange; // Couleur pour l'état En attente
      case 'Refusé':
        return Colors.red; // Couleur pour l'état Refusé
      default:
        return Colors.grey; // Couleur par défaut
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Accepté':
        return Icons.check_circle; // Icône pour Accepté
      case 'En attente':
        return Icons.hourglass_empty; // Icône pour En attente
      case 'Refusé':
        return Icons.cancel; // Icône pour Refusé
      default:
        return Icons.help; // Icône par défaut
    }
  }

  bool isDatePassed(String date) {
    final jobDate = DateTime.parse(date);
    return jobDate.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20), // Espacement entre le titre et la liste
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final isPassed = isDatePassed(jobs[index]['date']);
                  final statusColor = getStatusColor(jobs[index]['status']);
                  final statusIcon = getStatusIcon(jobs[index]['status']);
                  
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.business_center, // Icône pour le type de travail
                        color: Colors.blueAccent,
                        size: 40, // Augmenter la taille de l'icône
                      ),
                      title: Text(
                        jobs[index]['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Taille de police augmentée
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text('Postulé le: ${jobs[index]['date']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                statusIcon, // Icône pour l'état
                                size: 16,
                                color: statusColor, // Couleur en fonction de l'état
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'État: ${jobs[index]['status']}',
                                style: TextStyle(
                                  color: statusColor, // Couleur en fonction de l'état
                                  fontWeight: FontWeight.bold, // Mise en gras pour l'état
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor, // Couleur primaire du thème
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Espacement dans le bouton
                        ),
                        onPressed: () {
                          // Action à définir pour le bouton Détails
                        },
                        child: const Text(
                          'Détails',
                          style: TextStyle(color: Colors.white), // Couleur du texte
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
