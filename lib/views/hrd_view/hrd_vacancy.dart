import 'package:flutter/material.dart';
import 'package:jobseeker_app/controllers/hrd_controller.dart';
import 'package:jobseeker_app/controllers/vacancy_controller.dart';
import 'package:jobseeker_app/models/hrd_model.dart';
import 'package:jobseeker_app/models/vacancy_model.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/hrd_bottom_nav.dart';
import 'package:jobseeker_app/widgets/vacancy_listview.dart';

class HrdVacancy extends StatefulWidget {
  const HrdVacancy({super.key});

  @override
  State<HrdVacancy> createState() => _HrdVacancyState();
}

class _HrdVacancyState extends State<HrdVacancy> {
  List<VacancyModel> _vacancies = [];
  HrdModel? _profile;
  final VacancyController _vacancyController = VacancyController();
  final HrdController _controller = HrdController();

  bool _vacanciesActive = true;
  bool _chatActive = false;
  bool _isLoading = true;
  bool _isLoadingVacancies = true;
  String _errorMessage = '';
  String? logoUrl;

  Future<void> _loadLogo() async {
    final url = await _controller.loadInitialLogo();
    setState(() => logoUrl = url);
  } 

  // LOAD PROFILE
  Future<void> _loadProfile() async {
    final profile = await _controller.getProfile();
    setState(() {
      _isLoading = false;
      if (profile != null) {
        _profile = profile;
      } else {
        _errorMessage = 'Gagal memuat profil HRD';
      }
    });
  }

  Future<void> _loadVacancies() async {
    setState(() => _isLoadingVacancies = true);
    try {
      await _vacancyController.fetchCompanyVacancies(); // fetch dulu
      setState(() {
        _vacancies = _vacancyController
            .companyVacancies; // ambil datanya dari controller
        _isLoadingVacancies = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingVacancies = false;
      });
      print('Error load vacancies: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLogo();
    _loadProfile();
    _loadVacancies();
  }

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
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: _vacanciesActive
                                          ? ColorsApp.primarydark
                                          : ColorsApp.Grey2,
                                      width: 2))),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                overlayColor: Colors.transparent,
                                elevation: 0,
                                side: BorderSide(style: BorderStyle.none),
                                backgroundColor: ColorsApp.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _vacanciesActive = true;
                                  _chatActive = false;
                                });
                              },
                              child: Text(
                                "All Vacancies",
                                style: TextStyle(
                                  color: _vacanciesActive
                                      ? ColorsApp.primarydark
                                      : ColorsApp.Grey2,
                                  fontFamily: "Lato",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
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
                                      width: 2))),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                overlayColor: Colors.transparent,
                                elevation: 0,
                                side: BorderSide(style: BorderStyle.none),
                                backgroundColor: ColorsApp.white,
                              ),
                              onPressed: () {
                                setState(() {
                                  _vacanciesActive = false;
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 40),
                  child: _vacanciesActive
                      ? VacancyListView(vacancies: _vacancies, hrd: _profile)
                      : _chatActive
                          ? Center(child: Text("Chat"))
                          : Center(child: Text("No Data")),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: HrdBottomNav(2),
    );
  }
}
