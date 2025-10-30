  import 'package:flutter/material.dart';
  import 'package:jobseeker_app/widgets/colors.dart';

  class AppliedDetailsListview extends StatelessWidget {
    final String? status;

    const AppliedDetailsListview({super.key, this.status});

    @override
    Widget build(BuildContext context) {
      final List<Map<String, String>> appliedDetails = [
        {
          "Logo": "assets/dummy/netflix.jpg",
          "positionName": "Software Engineer",
          "companyName": "Tech Corp",
          "status": "Submitted",
        },
        {
          "Logo": "assets/dummy/netflix.jpg",
          "positionName": "UI UX Designer",
          "companyName": "Tech Corp",
          "status": "Accepted",
        },
        {
          "Logo": "assets/dummy/netflix.jpg",
          "positionName": "Graphic Designer",
          "companyName": "Tech Corp",
          "status": "Rejected",
        },
      ];

      // 🔹 Filter berdasarkan status
      final filteredAppliedDetails = (status == null || status == "All")
          ? appliedDetails
          : appliedDetails
              .where((appliedDetail) => appliedDetail["status"] == status)
              .toList();

      if (filteredAppliedDetails.isEmpty) {
        return const Center(child: Text("No Data"));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredAppliedDetails.length,
        itemBuilder: (context, index) {
          final appliedDetail = filteredAppliedDetails[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorsApp.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(appliedDetail["Logo"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appliedDetail["companyName"]!,
                          style: const TextStyle(
                            fontFamily: "Lato",
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          appliedDetail["positionName"]!,
                          style: const TextStyle(
                            fontFamily: "Lato",
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: ColorsApp.Grey2,
                  margin: const EdgeInsets.symmetric(vertical: 24),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          size: 12,
                          color: appliedDetail["status"] == "Submitted"
                              ? Colors.amber
                              : appliedDetail["status"] == "Accepted"
                                  ? Colors.green
                                  : appliedDetail["status"] == "Rejected"
                                      ? Colors.red
                                      : ColorsApp.Grey2,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          appliedDetail["status"]!,
                          style: TextStyle(
                            fontFamily: "Lato",
                            color: appliedDetail["status"] == "Submitted"
                                ? Colors.amber
                                : appliedDetail["status"] == "Accepted"
                                    ? Colors.green
                                    : appliedDetail["status"] == "Rejected"
                                        ? Colors.red
                                        : ColorsApp.Grey2,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Text(
                            "View Details",
                            style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: 12,
                              color: ColorsApp.primarydark,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward,
                            color: ColorsApp.primarydark,
                            size: 18,
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      );
    }
  }
