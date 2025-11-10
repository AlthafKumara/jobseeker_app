import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseeker_app/views/society_view/society_vacancy_details.dart';
import 'package:jobseeker_app/widgets/colors.dart';

class SocietyDashboardListView extends StatelessWidget {
  const SocietyDashboardListView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> jobs = [
      {
        "position_name": "Backend Developer",
        "company_name": "Telkom Indonesia",
        "company_address": "Malang City, Indonesia",
        "submission_start_date": "07 Nov 2025",
        "submission_end_date": "02 Dec 2025",
        "is_active": true,
      },
      {
        "position_name": "UI Designer",
        "company_name": "Telegram",
        "company_address": "Jakarta, Indonesia",
        "submission_start_date": "05 Nov 2025",
        "submission_end_date": "30 Nov 2025",
        "is_active": true,
      },
      {
        "position_name": "Human Resources",
        "company_name": "Autodesk",
        "company_address": "Bandung, Indonesia",
        "submission_start_date": "03 Nov 2025",
        "submission_end_date": "25 Nov 2025",
        "is_active": true,
      },
      {
        "position_name": "Backend Developer",
        "company_name": "Telkom Indonesia",
        "company_address": "Malang City, Indonesia",
        "submission_start_date": "07 Nov 2025",
        "submission_end_date": "02 Dec 2025",
        "is_active": true,
      },
      {
        "position_name": "UI Designer",
        "company_name": "Telegram",
        "company_address": "Jakarta, Indonesia",
        "submission_start_date": "05 Nov 2025",
        "submission_end_date": "30 Nov 2025",
        "is_active": true,
      },
      {
        "position_name": "Human Resources",
        "company_name": "Autodesk",
        "company_address": "Bandung, Indonesia",
        "submission_start_date": "03 Nov 2025",
        "submission_end_date": "25 Nov 2025",
        "is_active": true,
      },
    ];

    // Ambil hanya sampai batas maksimal (misal 5 item)
    final int maxLength = 5;
    final List<Map<String, dynamic>> visibleJobs =
        jobs.length > maxLength ? jobs.sublist(0, maxLength) : jobs;

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 16),
        itemCount: visibleJobs.length +
            (jobs.length > maxLength ? 1 : 0), // +1 untuk See More
        itemBuilder: (context, index) {
          // Jika index terakhir dan masih ada lebih banyak data → tampilkan "See More"
          if (index == visibleJobs.length && jobs.length > maxLength) {
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, "/society_search");
              },
              child: Container(
                width: 80,
                margin: const EdgeInsets.only(right: 8),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: ColorsApp.primarydark,
                      child: Icon(Icons.arrow_forward_ios,
                          size: 14, color: ColorsApp.white),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "See More",
                      style: TextStyle(
                        fontSize: 11,
                        color: ColorsApp.primarydark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final job = visibleJobs[index];

          // ✅ Parsing dan hitung "days ago"
          DateTime startDate =
              DateFormat("dd MMM yyyy").parse(job["submission_start_date"]!);
          int daysAgo = DateTime.now().difference(startDate).inDays;

          String updatedDateText = daysAgo < 0
              ? "Starts in ${daysAgo.abs()} days"
              : (daysAgo == 0 ? "Created today" : "Created $daysAgo days ago");

          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorsApp.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 4,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: ColorsApp.primarydark.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.work_outline,
                    color: ColorsApp.primarydark,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  job['company_name'],
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  job['position_name'],
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorsApp.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        job['company_address'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      updatedDateText,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SocietyVacancyDetails(),
                          ),
                        );
                      },
                      child: const Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 11,
                          color: ColorsApp.primarydark,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
