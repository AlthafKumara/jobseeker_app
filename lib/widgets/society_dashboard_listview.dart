import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseeker_app/views/society_view/society_applied_details.dart';
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
    ];

    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        clipBehavior: Clip.none,
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];

          // ✅ Parsing dan hitung "days ago"
          DateTime startDate =
              DateFormat("dd MMM yyyy").parse(job["submission_start_date"]!);
          int daysAgo = DateTime.now().difference(startDate).inDays;

          // ✅ Jika tanggal di masa depan → "Starts in ..."
          String updatedDateText = daysAgo < 0
              ? "Starts in ${daysAgo.abs()} days"
              : (daysAgo == 0 ? "Created today" : "Created $daysAgo days ago");

          return Container(
            width: 220,
            margin: EdgeInsets.only(
              right: index == jobs.length - 1 ? 0 : 16,
            ),
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
                // Icon perusahaan
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
                    // ✅ Menampilkan teks "Created ... days ago"
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
                            builder: (context) => const SocietyAppliedDetails(),
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
