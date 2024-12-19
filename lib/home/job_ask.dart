import 'package:flutter/material.dart';
import 'package:future_job/services/job_ask_service.dart';
import 'package:future_job/models/job_ask_model.dart'; // Modèle mis à jour

class JobAsk extends StatefulWidget {
  const JobAsk({super.key});

  @override
  State<JobAsk> createState() => _JobAskState();
}

class _JobAskState extends State<JobAsk> {
  final JobAskService _jobAskService = JobAskService(); // Instance du service
  List<JobAskModel> jobApplications = [];

  @override
  void initState() {
    super.initState();
    // Charger les demandes d'emploi depuis Firestore
    _loadJobApplications();
  }

  // Fonction pour charger les demandes d'emploi depuis Firestore
/*************  ✨ Codeium Command ⭐  *************/
  /// Charge les demandes d'emploi depuis Firestore et met à jour l'état
  /// de la liste des demandes d'emploi.
  ///
  /// Appelée dans [initState] pour charger les demandes d'emploi
  /// lors de l'initialisation du widget.
/******  1e9ec632-e212-4834-b3f3-d68bee5b7019  *******/ void
      _loadJobApplications() async {
    List<JobAskModel> jobs = await _jobAskService.getJobApplications();
    setState(() {
      jobApplications = jobs;
    });
  }

  // Mapping des états aux couleurs et icônes
  Color getStatusColor(String status) {
    switch (status) {
      case 'Accepté':
        return Colors.green;
      case 'En attente':
        return Colors.orange;
      case 'Refusé':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'Accepté':
        return Icons.check_circle;
      case 'En attente':
        return Icons.hourglass_empty;
      case 'Refusé':
        return Icons.cancel;
      default:
        return Icons.help;
    }
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
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: jobApplications.length,
                itemBuilder: (context, index) {
                  final job = jobApplications[index];
                  final statusColor = getStatusColor(job.status);
                  final statusIcon = getStatusIcon(job.status);

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.business_center,
                        color: Colors.blueAccent,
                        size: 40,
                      ),
                      title: Text(
                        job.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
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
                              Text('Postulé le: ${job.date}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                statusIcon,
                                size: 16,
                                color: statusColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'État: ${job.status}',
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        // onPressed: () {
                        //   // Mettre à jour le statut si nécessaire
                        //   // Exemple de mise à jour du statut
                        //   _jobAskService.updateJobStatus(
                        //     job.jobId, // Remplacer par l'ID du document
                        //     'Accepté', // Nouveau statut
                        //   );

                        // },
                        onPressed: () {},
                        child: const Text(
                          'Détails',
                          style: TextStyle(color: Colors.white),
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
