import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseeker_app/views/society_view/society_vacancy_details.dart';
import 'package:jobseeker_app/widgets/colors.dart';

class SocietyListViewDashboard extends StatelessWidget {
  const SocietyListViewDashboard({super.key});

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

    // Ambil hanya sampai batas maksimal
    final List<Map<String, dynamic>> visibleJobs =
        jobs.length > 7 ? jobs.sublist(0, 5) : jobs;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              itemCount: visibleJobs.length,
              itemBuilder: (context, index) {
                final job = visibleJobs[index];

                // ✅ Parsing dan hitung "days ago"
                DateTime startDate = DateFormat("dd MMM yyyy")
                    .parse(job["submission_start_date"]!);
                int daysAgo = DateTime.now().difference(startDate).inDays;

                // ✅ Jika tanggal di masa depan → "Starts in ..."
                String updatedDateText = daysAgo < 0
                    ? "Starts in ${daysAgo.abs()} days"
                    : (daysAgo == 0
                        ? "Created today"
                        : "Created $daysAgo days ago");

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  height: 140,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
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
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['company_name'],
                                style: const TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 11,
                                  color: ColorsApp.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                job['position_name'],
                                style: const TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsApp.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                job['company_address'],
                                style: const TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 11,
                                  color: ColorsApp.Grey1,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(updatedDateText,
                              style: const TextStyle(
                                fontSize: 11,
                                color: ColorsApp.Grey1,
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SocietyVacancyDetails(),
                                ),
                              );
                            },
                            child: const Text(
                              "View Details",
                              style: TextStyle(
                                fontSize: 11,
                                color: ColorsApp.primarydark,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
          if (visibleJobs.length < jobs.length)
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsApp.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: ColorsApp.primarydark,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, "/society_search"),
                child: Text(
                  'See more',
                  style: TextStyle(color: ColorsApp.primarydark),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
