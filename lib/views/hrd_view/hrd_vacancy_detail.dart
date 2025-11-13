import 'package:flutter/material.dart';
import 'package:jobseeker_app/models/hrd_model.dart';
import 'package:jobseeker_app/models/vacancy_model.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:intl/intl.dart';

class HrdVacancyDetail extends StatefulWidget {
  final VacancyModel vacancy;
  final HrdModel? hrd;

  const HrdVacancyDetail({
    super.key,
    required this.vacancy,
    this.hrd,
  });

  @override
  State<HrdVacancyDetail> createState() => _HrdVacancyDetailState();
}

class _HrdVacancyDetailState extends State<HrdVacancyDetail> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final vacancy = widget.vacancy;
    final hrd = widget.hrd;

    // 🔹 Pilih sumber data dengan aman (vacancy > hrd > fallback default)
    final companyname =
        (widget.hrd?.name != null && widget.hrd!.name!.isNotEmpty)
            ? widget.hrd!.name!
            : ((widget.vacancy.companyName != null &&
                    widget.vacancy.companyName!.isNotEmpty)
                ? widget.vacancy.companyName!
                : "Unknown Company");

    final companyaddress =
        (widget.hrd?.address != null && widget.hrd!.address!.isNotEmpty)
            ? widget.hrd!.address!
            : ((widget.vacancy.companyAddress != null &&
                    widget.vacancy.companyAddress!.isNotEmpty)
                ? widget.vacancy.companyAddress!
                : "Unknown Address");

    final companylogo =
        (widget.hrd?.logo != null && widget.hrd!.logo!.isNotEmpty)
            ? widget.hrd!.logo!
            : ((widget.vacancy.companyLogo != null &&
                    widget.vacancy.companyLogo!.isNotEmpty)
                ? widget.vacancy.companyLogo!
                : "");

    // 🔹 Hitung tanggal posting
    DateTime startDate;
    try {
      startDate = DateFormat("yyyy-MM-dd")
          .parse(vacancy.submissionStartDate.toString());
    } catch (_) {
      startDate = DateTime.now();
    }

    int daysAgo = DateTime.now().difference(startDate).inDays;
    String updatedDateText =
        daysAgo <= 0 ? "Created Today" : "Created $daysAgo days ago";

    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                      child: const Icon(Icons.arrow_back,
                          color: ColorsApp.primarydark, size: 20),
                    ),
                    const Text(
                      "Details",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Lato",
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(Icons.arrow_back,
                        color: ColorsApp.white, size: 20),
                  ],
                ),
                const SizedBox(height: 24),

                // 🔹 Company Info
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: companylogo.isNotEmpty
                          ? Image.network(
                              companylogo,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                color: ColorsApp.Grey2,
                                width: 60,
                                height: 60,
                                child: const Icon(Icons.image_not_supported,
                                    color: ColorsApp.Grey1),
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 60,
                              color: ColorsApp.Grey2,
                              child: const Icon(Icons.business,
                                  color: ColorsApp.Grey1),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          companyname,
                          style: const TextStyle(
                            fontFamily: "Lato",
                            color: ColorsApp.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vacancy.positionName,
                          style: const TextStyle(
                            fontFamily: "Lato",
                            color: ColorsApp.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Location
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: ColorsApp.primarydark, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        companyaddress,
                        style: const TextStyle(
                          fontFamily: "Lato",
                          color: ColorsApp.Grey1,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Info tanggal dan status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      updatedDateText,
                      style: const TextStyle(
                        fontFamily: "Lato",
                        color: ColorsApp.Grey1,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      vacancy.status ?? "",
                      style: TextStyle(
                        fontFamily: "Lato",
                        color: (vacancy.status ?? "").toLowerCase() == "active"
                            ? Colors.green
                            : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 🔹 Job Description
                const Text(
                  "Job Description",
                  style: TextStyle(
                    fontFamily: "Lato",
                    color: ColorsApp.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                _description(vacancy.description ?? "-"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Expandable Description
  Widget _description(String text) {
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Scrollbar(
            thumbVisibility: true,
            radius: const Radius.circular(10),
            thickness: 3,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    maxLines: isExpanded ? null : 5,
                    overflow: isExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(
                      wordSpacing: 2,
                      fontFamily: "Lato",
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      setState(() => isExpanded = !isExpanded);
                    },
                    child: Text(
                      isExpanded ? "See less" : "See more..",
                      style: const TextStyle(
                        fontFamily: "Lato",
                        color: ColorsApp.primarydark,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
