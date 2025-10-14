import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';

class SocietyVacancy extends StatefulWidget {
  const SocietyVacancy({super.key});

  @override
  State<SocietyVacancy> createState() => _SocietyVacancyState();
}

class _SocietyVacancyState extends State<SocietyVacancy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: Center(
        child: Text("Society Vacancy"),
      ),
      bottomNavigationBar: SocietyBottomNav(2),
    );
  }
}
