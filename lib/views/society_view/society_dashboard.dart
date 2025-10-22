import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';

class SocietyDashboard extends StatefulWidget {
  const SocietyDashboard({super.key});

  @override
  State<SocietyDashboard> createState() => _SocietyDashboardState();
}

class _SocietyDashboardState extends State<SocietyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Society Dashboard"),
      ),
      bottomNavigationBar: SocietyBottomNav(0),
    );
  }
}
