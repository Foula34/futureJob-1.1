// Widget: JobPost
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:future_job/home/job_detail_screen.dart';
import 'package:future_job/models/job_item_model.dart';
import 'package:future_job/services/jobs_service.dart';

class JobPost extends StatefulWidget {
  final JobItem jobItem;

  const JobPost({
    super.key,
    required this.jobItem,
  });

  @override
  _JobPostState createState() => _JobPostState();
}

class _JobPostState extends State<JobPost> {
  bool isLiked = false;
  final JobsService _jobsService = JobsService();

  @override
  void initState() {
    super.initState();
    isLiked = widget.jobItem.isFavorite;
  }

  Future<void> toggleFavoriteStatus() async {
    setState(() {
      isLiked = !isLiked;
    });

    try {
      await _jobsService.updateFavoriteStatus(widget.jobItem.id, isLiked);
    } catch (e) {
      print('Error updating favorite status: $e');
      // Revert state on error
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailsPage(jobItem: widget.jobItem),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            widget.jobItem.companyLogo.isNotEmpty
                ? Image.network(widget.jobItem.companyLogo, width: 40)
                : const Icon(Icons.business, size: 40),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.jobItem.jobTitle,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.jobItem.employmentType,
                    style: GoogleFonts.roboto(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.jobItem.salary,
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: toggleFavoriteStatus,
              icon: Icon(
                Icons.thumb_up,
                color: isLiked ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
