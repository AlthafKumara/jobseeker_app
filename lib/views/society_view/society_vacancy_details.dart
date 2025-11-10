import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobseeker_app/widgets/colors.dart';

class SocietyVacancyDetails extends StatefulWidget {
  const SocietyVacancyDetails({super.key});

  @override
  State<SocietyVacancyDetails> createState() => _SocietyVacancyDetailsState();
}

class _SocietyVacancyDetailsState extends State<SocietyVacancyDetails> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final company = {
      "name": "Telkom Indonesia",
      "logo": "",
      "address": "Malang City, Indonesia",
    };

    final vacancyDetail = {
      "positionName": "Software Engineer",
      "description":
          "Posisi Software Engineer di SMK Telkom Malang membuka kesempatan bagi individu yang bersemangat di bidang teknologi untuk berkontribusi dalam pengembangan sistem digital pendidikan. Kandidat akan berperan dalam merancang, mengembangkan, dan memelihara berbagai aplikasi serta sistem internal sekolah yang mendukung kegiatan akademik dan administrasi. Kolaborasi dengan tim IT, guru, dan manajemen menjadi bagian penting dalam menciptakan solusi inovatif dan efisien bagi lingkungan sekolah.\n\nKami mencari seseorang yang memiliki kemampuan pemrograman yang solid, memahami konsep pengembangan berbasis framework, serta terbiasa menggunakan bahasa pemrograman seperti JavaScript, Python, atau Java. Pengalaman dengan basis data, API, dan version control seperti Git akan menjadi nilai tambah. Lowongan ini hanya tersedia untuk 1 orang kandidat, dengan periode pendaftaran dari 1 November 2025 hingga 30 November 2025, dan saat ini berstatus Aktif. Bergabunglah bersama kami untuk menciptakan inovasi teknologi di dunia pendidikan digital.",
      "capacity": "1",
      "start_date": "01-11-2025",
      "end_date": "30-11-2025",
      "status": "Active",
    };

    // 🔹 Parsing tanggal dan menghitung selisih
    DateTime startDate =
        DateFormat("dd-MM-yyyy").parse(vacancyDetail["start_date"]!);
    int daysAgo = DateTime.now().difference(startDate).inDays;

    // 🔹 Jika tanggal di masa depan
    String updatedDateText = daysAgo < 0
        ? "Starts in ${daysAgo.abs()} days"
        : "Created $daysAgo days ago";

    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back,
                          color: ColorsApp.primarydark, size: 20),
                    ),
                    const Text(
                      "Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Lato",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.arrow_back, color: ColorsApp.white, size: 20),
                  ],
                ),
                SizedBox(height: 24),
                // Company Info
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        image: company["logo"] != ""
                            ? DecorationImage(
                                image: NetworkImage(company["logo"]!),
                                fit: BoxFit.cover,
                              )
                            : null,
                        color: ColorsApp.Grey2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          company["name"] ?? "",
                          style: TextStyle(
                            fontFamily: "Lato",
                            color: ColorsApp.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vacancyDetail["positionName"] ?? "",
                          style: TextStyle(
                            fontFamily: "Lato",
                            color: ColorsApp.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: ColorsApp.primarydark, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      company["address"] ?? "",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: ColorsApp.Grey1,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Created ... days ago
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      updatedDateText,
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: ColorsApp.Grey1,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      vacancyDetail["status"]!,
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: vacancyDetail["status"] == "Active"
                            ? Colors.green
                            : vacancyDetail["status"] == "Inactive"
                                ? Colors.red
                                : ColorsApp.Grey1,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Job Description
                Text(
                  "Job Description",
                  style: TextStyle(
                    fontFamily: "Lato",
                    color: ColorsApp.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                _description(vacancyDetail["description"] ?? ""),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: ColorsApp.primarydark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {},
          child: const Text(
            'Apply',
            style: TextStyle(
              color: ColorsApp.white,
              fontFamily: "Lato",
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _description(String text) {
    return Container(
      height: 140,
      child: Stack(
        children: [
          Scrollbar(
            thumbVisibility: true,
            radius: const Radius.circular(10),
            thickness: 3,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    maxLines: isExpanded ? null : 5,
                    overflow:
                        isExpanded ? TextOverflow.visible : TextOverflow.clip,
                    style: const TextStyle(
                      wordSpacing: 2,
                      fontFamily: "Lato",
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() => isExpanded = !isExpanded);
                    },
                    child: Text(
                      isExpanded ? "See less" : "See more..",
                      style: const TextStyle(
                        fontFamily: "Lato",
                        color: ColorsApp.primarydark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
