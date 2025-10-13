import 'package:flutter/material.dart';

class HrdDashboard extends StatefulWidget {
  const HrdDashboard({super.key});

  @override
  State<HrdDashboard> createState() => _HrdDashboardState();
}

class _HrdDashboardState extends State<HrdDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("HRD Dashboard"),
      ),
    );
  }
}
