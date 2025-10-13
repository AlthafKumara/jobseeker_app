import 'package:flutter/material.dart';

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
    );
  }
}
