import 'package:flutter/material.dart';
import 'package:jobseeker_app/models/position_applied_model.dart';
import 'package:jobseeker_app/models/vacancy_model.dart';
import 'package:jobseeker_app/views/society_view/society_applied_result.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:intl/intl.dart';

class SocietyAppliedStatus extends StatelessWidget {
  final VacancyModel vacancy;
  final PositionAppliedModel position;
  const SocietyAppliedStatus(
      {super.key, required this.vacancy, required this.position});

  @override
  Widget build(BuildContext context) {
    DateTime reviewDate = position.applyDate.add(const Duration(days: 7));
    String formattedDate = DateFormat('dd MMMM yyyy').format(reviewDate);
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
                      "Applied Job details",
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

                // 🔹 Info Lowongan
                vacancyInfo(vacancy),
                const SizedBox(height: 24),
                Text(
                  "Track Your Application",
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: ColorsApp.black,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Status : ",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ColorsApp.black,
                      ),
                    ),
                    Text(
                      position.status ?? "-",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: position.status == "PENDING"
                            ? Colors.orange
                            : position.status == "REJECTED"
                                ? Colors.red
                                : position.status == "ACCEPTED"
                                    ? Colors.green
                                    : ColorsApp.Grey1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                position.status == "PENDING"
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Your application is pending",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Estimated for the review until : $formattedDate",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primarydark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Your application ${position.status}",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: position.status == "REJECTED"
                                      ? Colors.red
                                      : position.status == "ACCEPTED"
                                          ? Colors.green
                                          : ColorsApp.Grey1,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Check below for more details",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: ColorsApp.primarydark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: position.status == "PENDING"
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 30),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/society_dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.primarydark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Go to Dashboard",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )),
            )
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 30),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SocietyAppliedResult(
                                  vacancy: vacancy,
                                  position: position,
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsApp.primarydark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Review Response From Company",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )),
            ),
    );
  }

  Widget vacancyInfo(VacancyModel vacancy) {
    final companylogo = vacancy.companyLogo;
    final companyname = vacancy.companyName ?? "-";
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
              image: companylogo != null && companylogo.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(companylogo),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (companylogo == null || companylogo.isEmpty)
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
                  companyname,
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
}
