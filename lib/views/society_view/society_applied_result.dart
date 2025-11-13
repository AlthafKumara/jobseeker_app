import 'package:flutter/material.dart';
import 'package:jobseeker_app/models/position_applied_model.dart';
import 'package:jobseeker_app/models/vacancy_model.dart';
import 'package:jobseeker_app/widgets/colors.dart';

class SocietyAppliedResult extends StatelessWidget {
  final VacancyModel vacancy;
  final PositionAppliedModel position;
  const SocietyAppliedResult(
      {super.key, required this.vacancy, required this.position});

  @override
  Widget build(BuildContext context) {
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
                      "Message ",
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
                Text(position.message ?? "Tidak Ada pesan yang diberikan",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: ColorsApp.black,
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
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
              "Back to Dashboard",
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
}
