import 'package:flutter/material.dart';
import 'package:jobseeker_app/widgets/colors.dart';
import 'package:jobseeker_app/widgets/customtextfield.dart';
import 'package:jobseeker_app/widgets/society_bottom_nav.dart';

class SocietySearch extends StatefulWidget {
  const SocietySearch({super.key});

  @override
  State<SocietySearch> createState() => _SocietySearchState();
}

class _SocietySearchState extends State<SocietySearch> {
  final TextEditingController _searchcontroller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _shouldAutoFocus = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ambil argument yang dikirim
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    _shouldAutoFocus = args?["fromdashboard"] == true;

    // Jalankan autofocus hanya jika fromdashboard == true
    if (_shouldAutoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNode);
      });
    }
  }

  @override
  void dispose() {
    _searchcontroller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsApp.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _searchcontroller,
                focusNode: _focusNode,
                hintText: "Search",
                suffixIcon: Image.asset(
                  "assets/navbar/Search_on.png",
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SocietyBottomNav(1),
    );
  }
}
