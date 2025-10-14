import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/hrd_bottom_nav.dart';

class HrdVacancy extends StatefulWidget {
  const HrdVacancy({super.key});

  @override
  State<HrdVacancy> createState() => _HrdVacancyState();
}

class _HrdVacancyState extends State<HrdVacancy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HRD Vacancy"),
      ),
      bottomNavigationBar: HrdBottomNav(2),
    );
  }
}
