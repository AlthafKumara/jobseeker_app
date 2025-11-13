import 'package:flutter/material.dart';
import 'package:jobseeker_app/controllers/vacancy_controller.dart';
import 'package:jobseeker_app/models/position_applied_model.dart';
import 'package:jobseeker_app/models/vacancy_model.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/customtextfield.dart';

class HrdDecision extends StatefulWidget {
  final VacancyModel vacancy;
  final PositionAppliedModel position;
  final VacancyController controller;

  const HrdDecision({
    super.key,
    required this.vacancy,
    required this.position,
    required this.controller,
  });

  @override
  State<HrdDecision> createState() => _HrdDecisionState();
}

class _HrdDecisionState extends State<HrdDecision> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  String? _selectedStatus; // “Accepted” atau “Rejected”

  // 🔹 Fungsi update status lewat controller
  Future<void> _updateStatus(
    BuildContext context,
    String applicationId,
    String status,
    String message,
  ) async {
    setState(() => _isLoading = true);

    // Pastikan status dikirim sesuai enum backend (UPPERCASE)
    final upperStatus = status.toUpperCase();

    final success = await widget.controller.updateApplicantStatus(
      applicationId: applicationId,
      status: upperStatus,
      message: message,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? "Applicant has been $upperStatus."
              : "Failed to update: ${widget.controller.errorMessage ?? ''}",
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      Navigator.pushReplacementNamed(context, "/hrd_dashboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicant = widget.position;
    final society = applicant.society ?? {};

    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: ColorsApp.primarydark,
                        size: 20,
                      ),
                    ),
                    const Text(
                      "Decision",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Lato",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),

                const SizedBox(height: 24),

                appliedInfo(society, applicant),

                const SizedBox(height: 24),

                const Text(
                  "Message",
                  style: TextStyle(
                    fontFamily: "Lato",
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _messageController,
                  hintText: "Insert message...",
                  maxLines: 6,
                  enabled: !_isLoading,
                ),

                const SizedBox(height: 24),

                // 🔹 Tombol Aksi (Accepted / Rejected)
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorsApp.primarydark,
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: _selectedStatus == "Rejected"
                                    ? ColorsApp.primarydark.withOpacity(0.1)
                                    : ColorsApp.white,
                                foregroundColor: ColorsApp.primarydark,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side: const BorderSide(
                                  width: 1,
                                  color: ColorsApp.primarydark,
                                ),
                              ),
                              onPressed: () {
                                setState(() => _selectedStatus = "Rejected");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Rejected",
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (_selectedStatus == "Rejected") ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.check,
                                        size: 14, color: ColorsApp.primarydark),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: ColorsApp.white,
                                backgroundColor: _selectedStatus == "Accepted"
                                    ? ColorsApp.primarydark
                                    : ColorsApp.primarydark.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() => _selectedStatus = "Accepted");
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Accepted",
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (_selectedStatus == "Accepted") ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.check,
                                        size: 14, color: Colors.white),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        child: bottomNav(applicant.id.toString()),
      ),
    );
  }

  // 🔹 Widget Info Pelamar
  Widget appliedInfo(
      Map<String, dynamic> society, PositionAppliedModel applicant) {
    final positionName = applicant.availablePosition?['position_name'] ?? "-";

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
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: society["profile_photo"] != null
                ? NetworkImage(society["profile_photo"])
                : null,
            backgroundColor: ColorsApp.primarydark,
            radius: 20,
            child: society["profile_photo"] != null
                ? null
                : const Icon(Icons.person_2_outlined,
                    color: ColorsApp.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                society["name"] ?? "Unknown",
                style: const TextStyle(
                  fontFamily: "Lato",
                  color: ColorsApp.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                positionName,
                style: const TextStyle(
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
    );
  }

  // 🔹 Tombol Submit di bawah
  Widget bottomNav(String applicationId) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ColorsApp.white,
              backgroundColor: ColorsApp.primarydark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _isLoading
                ? null
                : () {
                    if (_selectedStatus == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please select Accepted or Rejected"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    if (_messageController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a message"),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      return;
                    }

                    _updateStatus(
                      context,
                      applicationId,
                      _selectedStatus!,
                      _messageController.text.trim(),
                    );
                  },
            child: const Text(
              "Submit Decision",
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
