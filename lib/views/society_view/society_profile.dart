import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';

class SocietyProfile extends StatefulWidget {
  const SocietyProfile({super.key});

  @override
  State<SocietyProfile> createState() => _SocietyProfileState();
}

class _SocietyProfileState extends State<SocietyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Society Profile"),
      ),
      bottomNavigationBar: SocietyBottomNav(3),
    );
  }
}