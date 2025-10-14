import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/hrd_bottom_nav.dart';

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
      bottomNavigationBar: HrdBottomNav(0),
    );
  }
}
