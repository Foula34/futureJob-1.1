import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:future_job/models/job_item_model.dart';

class JobDetailsPage extends StatelessWidget {
  final JobItem jobItem;

  const JobDetailsPage({super.key, required this.jobItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Détails du poste',
          style: GoogleFonts.roboto(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 24,
                    backgroundImage: AssetImage(jobItem.companyLogo),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    // Utilisation de Expanded pour éviter le dépassement
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          jobItem.jobTitle,
                          style: GoogleFonts.roboto(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          // Utilisation de Wrap pour gérer le dépassement
                          children: [
                            Text(jobItem.companyName,
                                style: GoogleFonts.roboto(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('•', style: GoogleFonts.roboto(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(jobItem.location,
                                style: GoogleFonts.roboto(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text('Il y a 1 jour',
                                style: GoogleFonts.roboto(fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Description du poste',
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                jobItem.jobDescription,
                style: GoogleFonts.roboto(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Text(
                'Exigences',
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ...jobItem.requirements.map((requirement) => Text(
                    '• $requirement',
                    style: GoogleFonts.roboto(fontSize: 16),
                  )),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/subscribe');
                },
                child: Container(
                  width: 300.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Postuler".toUpperCase(),
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
