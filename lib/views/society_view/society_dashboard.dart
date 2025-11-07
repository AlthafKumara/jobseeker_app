import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/customtextfield.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';
import 'package:jobseeker_app/widgets/society_dashboard_listview.dart';

class SocietyDashboard extends StatefulWidget {
  const SocietyDashboard({super.key});

  @override
  State<SocietyDashboard> createState() => _SocietyDashboardState();
}

class _SocietyDashboardState extends State<SocietyDashboard> {
  TextEditingController _searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final societyuser = {
      "name": "John Doe",
      "role": "Society",
      "profile_picture": "https://example.com/profile.jpg",
    };



    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // USER
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage:
                          NetworkImage(societyuser["profile_picture"]!),
                      backgroundColor: ColorsApp.primarydark,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          societyuser["name"] ?? "",
                          style: const TextStyle(
                            fontFamily: "Lato",
                            color: ColorsApp.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          societyuser["role"] ?? "",
                          style: const TextStyle(
                            fontFamily: "Lato",
                            color: ColorsApp.primarydark,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),
                CustomTextField(
                    controller: _searchcontroller,
                    hintText: "Search",
                    suffixIcon: Image.asset("assets/navbar/Search_on.png",
                        width: 20, height: 20)),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Curated Jobs For You",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: ColorsApp.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 200,
                  margin: EdgeInsets.symmetric(vertical: 24),
                  child: SocietyDashboardListView(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SocietyBottomNav(0),
    );
  }
}
