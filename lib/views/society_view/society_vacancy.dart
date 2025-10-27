import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';

class SocietyVacancy extends StatefulWidget {
  const SocietyVacancy({super.key});

  @override
  State<SocietyVacancy> createState() => _SocietyVacancyState();
}

class _SocietyVacancyState extends State<SocietyVacancy> {
  int selectedStatus = 0;

  bool _appliedActive = true;
  bool _chatActive = false;

  // List status (biar tidak nulis berulang)
  final List<String> statuses = [
    "All",
    "Submitted",
    "Interview",
    "Accepted",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // --- TAB: Applied / Chat ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _appliedActive
                                  ? ColorsApp.primarydark
                                  : ColorsApp.Grey2,
                              width: 2,
                            ),
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            overlayColor: Colors.transparent,
                            elevation: 0,
                            side: BorderSide.none,
                            backgroundColor: ColorsApp.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _appliedActive = true;
                              _chatActive = false;
                            });
                          },
                          child: Text(
                            "Applied Job Details",
                            style: TextStyle(
                              color: _appliedActive
                                  ? ColorsApp.primarydark
                                  : ColorsApp.Grey2,
                              fontFamily: "Lato",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _chatActive
                                  ? ColorsApp.primarydark
                                  : ColorsApp.Grey2,
                              width: 2,
                            ),
                          ),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            overlayColor: Colors.transparent,
                            elevation: 0,
                            side: BorderSide.none,
                            backgroundColor: ColorsApp.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _appliedActive = false;
                              _chatActive = true;
                            });
                          },
                          child: Text(
                            "Chat",
                            style: TextStyle(
                              color: _chatActive
                                  ? ColorsApp.primarydark
                                  : ColorsApp.Grey2,
                              fontFamily: "Lato",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: _appliedActive
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: List.generate(statuses.length, (index) {
                              return statusButton(
                                statuses[index],
                                selectedStatus == index,
                                () {
                                  setState(() {
                                    selectedStatus = index;
                                  });
                                },
                              );
                            }),
                          ),
                        )
                      : _chatActive
                          ? Center(child: Text("Chat"))
                          : Center(child: Text("No Data")),
                ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SocietyBottomNav(2),
    );
  }

  Widget statusButton(String text, bool isSelected, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? ColorsApp.primarydark : ColorsApp.white,
        foregroundColor: isSelected ? ColorsApp.white : ColorsApp.primarydark,
        side: BorderSide(
          color: isSelected ? ColorsApp.primarydark : ColorsApp.Grey2,
          width: 1.3,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: "Lato",
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
