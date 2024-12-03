import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/home/job_detail_screen.dart';

class JobCard extends StatelessWidget {
  final JobItem jobItem;

  const JobCard({
    super.key,
    required this.jobItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsPage(jobItem: jobItem),
          ),
        );
      },
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Utilisation de NetworkImage pour afficher l'image depuis l'URL
                Image.network(
                  jobItem.companyLogo,
                  width: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red);
                  },
                ),
                const Spacer(),
                if (jobItem.isFavorite)
                  const Icon(Icons.favorite, color: Colors.red),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              jobItem.jobTitle,
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              jobItem.companyName,
              style: GoogleFonts.roboto(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              jobItem.salary,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              jobItem.location,
              style: GoogleFonts.roboto(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
