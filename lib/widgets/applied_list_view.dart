import 'package:flutter/material.dart';
import 'package:jobseeker_app/controllers/vacancy_controller.dart';
import 'package:jobseeker_app/models/position_applied_model.dart';
import 'package:jobseeker_app/models/vacancy_model.dart';
import 'package:jobseeker_app/utils/file_util.dart';
import 'package:jobseeker_app/views/hrd_view/hrd_applied_details.dart';
import 'package:jobseeker_app/widgets/colors.dart';

class AppliedListView extends StatefulWidget {
  final VacancyController controller;

  const AppliedListView({
    super.key,
    required this.controller,
  });

  @override
  State<AppliedListView> createState() => _AppliedListViewState();
}

class _AppliedListViewState extends State<AppliedListView> {
  List<PositionAppliedModel> applicants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplicants();
  }

  Future<void> _loadApplicants() async {
    setState(() => isLoading = true);

    final result = await widget.controller.getAllCompanyApplicants();

    setState(() {
      applicants = result
          .map((applicant) => PositionAppliedModel.fromJson(applicant))
          .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.controller.errorMessage != null) {
      return Center(
        child: Text(
          "Error: ${widget.controller.errorMessage}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (applicants.isEmpty) {
      return const Center(child: Text("No applicants yet."));
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: applicants.length,
      itemBuilder: (context, index) {
        final applicant = applicants[index];
        final society = applicant.society ?? {};
        final portfolio = applicant.portfolio ?? {};
        final position = applicant.availablePosition ?? {};

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          decoration: BoxDecoration(
            color: ColorsApp.white,
            borderRadius: BorderRadius.circular(12),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: society["profile_photo"] != null
                        ? NetworkImage(society["profile_photo"] ?? "")
                        : null,
                    backgroundColor: ColorsApp.primarydark,
                    radius: 20,
                    child: society["profile_photo"] != null
                        ? null
                        : Icon(Icons.person_2_outlined,
                            color: ColorsApp.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        society["name"] ?? "Unknown",
                        style: TextStyle(
                          fontFamily: "Lato",
                          color: ColorsApp.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        position["position_name"] ?? "-",
                        style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 12,
                          color: ColorsApp.Grey2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildButton(applicant),
            ],
          ),
        );
      },
    );
  }

  Widget _buildButton(PositionAppliedModel applicant) {
    final portfolio = applicant.portfolio ?? {};
    final society = applicant.society ?? {};
    final position = applicant.availablePosition ?? {};

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: ColorsApp.white,
              foregroundColor: ColorsApp.primarydark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(
                width: 1,
                color: ColorsApp.primarydark,
              ),
            ),
            onPressed: () {
              final vacancy = VacancyModel.fromJson(position);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HrdAppliedDetails(
                    vacancy: vacancy,
                    applicant: applicant,
                  ),
                ),
              );

              if (portfolio["file"] != null) {
                openRemotePdf(
                  portfolio["file"]!,
                  fileName: Uri.decodeComponent(
                    portfolio["file"]!.split('/').last,
                  ),
                );
              }
            },
            child: const Text(
              "See Resume",
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorsApp.white,
              backgroundColor: ColorsApp.primarydark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final vacancy = VacancyModel.fromJson(position);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HrdAppliedDetails(
                    vacancy: vacancy,
                    applicant: applicant,
                  ),
                ),
              );
            },
            child: const Text(
              "See Details",
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
