import 'package:flutter/material.dart';
import 'package:jobseeker_app/controllers/vacancy_controller.dart';
import 'package:jobseeker_app/models/position_applied_model.dart';
import 'package:jobseeker_app/models/vacancy_model.dart';
import 'package:jobseeker_app/utils/file_util.dart';
import 'package:jobseeker_app/views/hrd_view/hrd_decision.dart';
import 'package:jobseeker_app/widgets/colors.dart';

class HrdAppliedDetails extends StatefulWidget {
  final VacancyModel vacancy;
  final PositionAppliedModel applicant;

  const HrdAppliedDetails({
    super.key,
    required this.vacancy,
    required this.applicant,
  });

  @override
  State<HrdAppliedDetails> createState() => _HrdAppliedDetailsState();
}

class _HrdAppliedDetailsState extends State<HrdAppliedDetails> {
  @override
  Widget build(BuildContext context) {
    final vacancy = widget.vacancy;
    final applicant = widget.applicant;
    final society = applicant.society ?? {};
    final portfolio = applicant.portfolio ?? {};
    final coverLetter = applicant.coverLetter ?? "-";

    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: ColorsApp.primarydark,
                        size: 20,
                      ),
                    ),
                    const Text(
                      "Application",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Lato",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 24),

                // 🔹 Vacancy Info
                vacancyInfo(vacancy),

                const SizedBox(height: 24),

                // 🔹 Applicant Info
                Text(
                  "Applicant",
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.black,
                  ),
                ),
                const SizedBox(height: 12),
                applicantInfo(society, vacancy),

                const SizedBox(height: 20),

                // 🔹 Resume Button
                _buildResumeButton(portfolio),

                const SizedBox(height: 24),

                // 🔹 Cover Letter
                Text(
                  "Cover Letter",
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorsApp.black,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  coverLetter.isNotEmpty ? coverLetter : "-",
                  style: const TextStyle(
                    fontFamily: "Lato",
                    fontSize: 12,
                    color: ColorsApp.Grey2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        child: _buildbutton(
          applicant,
          vacancy,
        ),
      ),
    );
  }

  // 🔹 Applicant Info Section
  Widget applicantInfo(Map<String, dynamic> society, VacancyModel vacancy) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: ColorsApp.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: society["profile_photo"] != null
                ? NetworkImage(society["profile_photo"])
                : null,
            backgroundColor: ColorsApp.primarydark,
            radius: 20,
            child: society["profile_photo"] != null
                ? null
                : const Icon(Icons.person_2_outlined,
                    color: ColorsApp.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                society["name"] ?? "Unknown",
                style: const TextStyle(
                  fontFamily: "Lato",
                  color: ColorsApp.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Button to View Resume
  Widget _buildResumeButton(Map<String, dynamic> portfolio) {
    return GestureDetector(
      onTap: () async {
        if (portfolio["file"] != null &&
            portfolio["file"].toString().isNotEmpty) {
          openRemotePdf(
            portfolio["file"]!,
            fileName: Uri.decodeComponent(
              portfolio["file"]!.split('/').last,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No resume file available")),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: ColorsApp.Grey3),
          borderRadius: BorderRadius.circular(12),
          color: ColorsApp.primarylight,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(
              "assets/image/pdf.png",
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // 🔹 Bersihkan "%20" dari nama file
                    Uri.decodeComponent(
                      portfolio["file"]!.split('/').last,
                    ),
                    style: const TextStyle(
                      fontFamily: "Lato",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Vacancy Info Section
  Widget vacancyInfo(VacancyModel vacancy) {
    final companyLogo = vacancy.companyLogo ?? "";
    final companyName = vacancy.companyName ?? "-";
    final position = vacancy.positionName;
    final address = vacancy.companyAddress ?? "-";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: ColorsApp.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🔹 Logo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorsApp.Grey2,
              borderRadius: BorderRadius.circular(8),
              image: companyLogo.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(companyLogo),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: companyLogo.isEmpty
                ? const Icon(Icons.apartment, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 16),

          // 🔹 Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  position,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: ColorsApp.Grey1,
                    fontFamily: "Lato",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildbutton(PositionAppliedModel applicant, VacancyModel vacancy) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorsApp.white,
              backgroundColor: ColorsApp.primarydark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HrdDecision(
                    vacancy: vacancy,
                    position: applicant,
                    controller: VacancyController(),
                  ),
                ),
              );
            },
            child: const Text(
              "Make A Decision",
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
