import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';

class SocietySearch extends StatefulWidget {
  const SocietySearch({super.key});

  @override
  State<SocietySearch> createState() => _SocietySearchState();
}

class _SocietySearchState extends State<SocietySearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Society Search"),
      ),
      bottomNavigationBar: SocietyBottomNav(1),
    );
  }
}
